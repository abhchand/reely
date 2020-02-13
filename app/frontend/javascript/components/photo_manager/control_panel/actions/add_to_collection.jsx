import axios from 'axios';
import { IconPlus } from 'components/icons';
import PropTypes from 'prop-types';
import React from 'react';
import ReactOnRails from 'react-on-rails/node_package/lib/Authenticity';
import ReactSelectOrCreate from 'react-select-or-create';

class AddToCollection extends React.Component {

  static propTypes = {
    collections: PropTypes.array.isRequired,
    // eslint-disable-next-line react/no-unused-prop-types
    updateCollections: PropTypes.func.isRequired,
    selectedPhotoIds: PropTypes.array.isRequired,
    // eslint-disable-next-line react/no-unused-prop-types
    onComplete: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props);

    this.i18nPrefix = 'components.photo_manager.control_panel.add_to_collection';

    this.addToExistingCollection = this.addToExistingCollection.bind(this);
    this.addToNewCollection = this.addToNewCollection.bind(this);
    this.addNotification = this.addNotification.bind(this);
  }

  addToExistingCollection(collectionId) {
    const self = this;
    // eslint-disable-next-line no-magic-numbers, newline-per-chained-call
    const id = `id${Math.random().toString(16).slice(2)}`;

    const url = `/collections/${collectionId}/add-photos`;
    /* eslint-disable camelcase */
    const data = {
      collection_id: collectionId,
      collection: {
        photo_ids: this.props.selectedPhotoIds
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
      then((_response) => {
        const count = self.props.selectedPhotoIds.length;
        const msg = I18n.t(`${self.i18nPrefix}.existing.success`, { count: count, href: '/collections' });
        // eslint-disable-next-line react/no-danger
        const content = <span dangerouslySetInnerHTML={{ __html: msg }} />;
        const notification = { id: id, content: content, type: 'success' };

        self.addNotification(notification);
        self.props.onComplete();
      }).
      catch((_err) => {
        const content = I18n.t(`${self.i18nPrefix}.existing.error`);
        const notification = { id: id, content: content, type: 'error' };

        self.addNotification(notification);
        self.props.onComplete();
      });
  }

  addToNewCollection(collectionName, prevCollections) {
    const self = this;
    // eslint-disable-next-line no-magic-numbers, newline-per-chained-call
    const id = `id${Math.random().toString(16).slice(2)}`;

    const url = '/collections';
    const data = {
      collection: {
        name: collectionName
      }
    };
    const config = {
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': ReactOnRails.authenticityToken()
      }
    };

    return axios.post(url, data, config).
      then((response) => {
        const collection = response.data;

        const collectionId = collection.id;
        const msg = I18n.t(`${self.i18nPrefix}.new.success`, { href: `/collections/${collectionId}`, name: collection.name });
        // eslint-disable-next-line react/no-danger
        const content = <span dangerouslySetInnerHTML={{ __html: msg }} />;
        const notification = { id: id, content: content, type: 'success' };

        self.addNotification(notification);
        self.addToExistingCollection(collectionId);

        prevCollections.unshift({ id: collection.id, name: collection.name });

        self.props.updateCollections(prevCollections);
        return prevCollections;
      }).
      catch((_err) => {
        const content = I18n.t(`${self.i18nPrefix}.new.error`);
        const notification = { id: id, content: content, type: 'error' };

        self.addNotification(notification);

        return prevCollections;
      });
  }

  addNotification(notification) {
    window.action_notifications.add(notification);
  }

  render() {
    const textForCloseMenuButton = I18n.t(`${this.i18nPrefix}.btn_label`);
    const textForOpenMenuButton = () => <IconPlus size="20" title={I18n.t(`${this.i18nPrefix}.tooltip`)} />;
    const textForEmptyState = I18n.t(`${this.i18nPrefix}.empty_state`);
    const textForNoSearchResults = I18n.t(`${this.i18nPrefix}.no_results`);
    const textForSearchInputPlaceholder = I18n.t(`${this.i18nPrefix}.search_placeholder`);
    const textForCreateItem = (searchValue) => {
      const key = searchValue === '' ? 'blank' : 'present';
      return I18n.t(`${this.i18nPrefix}.create.${key}`, { name: searchValue });
    };

    return (
      <li className="icon-tray__item icon-tray__item--add-to-collection">
        <ReactSelectOrCreate
          items={this.props.collections}
          onCreate={this.addToNewCollection}
          onSelect={this.addToExistingCollection}
          textForCloseMenuButton={textForCloseMenuButton}
          textForOpenMenuButton={textForOpenMenuButton}
          textForEmptyState={textForEmptyState}
          textForNoSearchResults={textForNoSearchResults}
          textForSearchInputPlaceholder={textForSearchInputPlaceholder}
          textForCreateItem={textForCreateItem} />
      </li>
    );
  }

}

export default AddToCollection;
