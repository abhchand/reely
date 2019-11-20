import axios from 'axios';
import { IconCopy } from 'components/icons';
import PropTypes from 'prop-types';
import React from 'react';
import ReactOnRails from 'react-on-rails/node_package/lib/Authenticity';

class RemoveFromCollection extends React.Component {

  static propTypes = {
    photoIdsToRemove: PropTypes.array.isRequired,
    currentCollection: PropTypes.object.isRequired,
    // eslint-disable-next-line react/no-unused-prop-types
    afterRemoval: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props);

    this.i18nPrefix = 'components.photo_manager.control_panel.remove_from_collection';

    this.removeFromCollection = this.removeFromCollection.bind(this);
    this.addNotification = this.addNotification.bind(this);
  }

  removeFromCollection() {
    const self = this;
    // eslint-disable-next-line no-magic-numbers, newline-per-chained-call
    const id = `id${Math.random().toString(16).slice(2)}`;

    const url = `/collections/${this.props.currentCollection.id}/remove-photos`;
    /* eslint-disable camelcase */
    const data = {
      collection_id: this.props.currentCollection.id,
      collection: {
        photo_ids: this.props.photoIdsToRemove
      }
    };
    /* eslint-enable camelcase */
    const config = {
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': ReactOnRails.authenticityToken()
      }
    };

    axios.put(url, data, config).
      then((response) => {
        const msg = I18n.t(`${self.i18nPrefix}.success`, { count: this.props.photoIdsToRemove.length });
        // eslint-disable-next-line react/no-danger
        const content = <span dangerouslySetInnerHTML={{ __html: msg }} />;
        const notification = { id: id, content: content, type: 'success' };

        self.updateDateRangeLabel(response.data.date_range_label);
        self.updatePhotoCount(response.data.photo_count);
        self.addNotification(notification);
        self.props.afterRemoval();
      }).
      catch((_err) => {
        const content = I18n.t(`${self.i18nPrefix}.error`);
        const notification = { id: id, content: content, type: 'error' };

        self.addNotification(notification);
      });
  }

  addNotification(notification) {
    window.action_notifications.add(notification);
  }

  updateDateRangeLabel(label) {
    const el = document.querySelector('.collections-show__date-range');

    if (label === null) {
      while (el.firstChild) el.removeChild(el.firstChild);
    }
    else if (typeof label !== 'string' || label.length === 0) {
      // Nothing
    }
    else {
      el.innerHTML = label;
    }
  }

  updatePhotoCount(count) {
    if (typeof count !== 'number' || count < 0) {
      return;
    }

    const el = document.querySelector('.photo-count');
    el.innerHTML = I18n.t('shared.photo_count.label', { count: count });
  }

  render() {
    return (
      <li className="icon-tray__item icon-tray__item--remove-from-collection" onClick={this.removeFromCollection}>
        <IconCopy size="24" title={I18n.t(`${this.i18nPrefix}.tooltip`)} fillColor="#000000" />
      </li>
    );
  }

}

export default RemoveFromCollection;
