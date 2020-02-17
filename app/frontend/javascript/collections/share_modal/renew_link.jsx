import axios from 'axios';
import PropTypes from 'prop-types';
import React from 'react';
import ReactOnRails from 'react-on-rails/node_package/lib/Authenticity';

class RenewLink extends React.Component {

  static propTypes = {
    collection: PropTypes.object.isRequired,
    // eslint-disable-next-line react/no-unused-prop-types
    setCollection: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props);

    this.onClick = this.onClick.bind(this);
    this.renderLink = this.renderLink.bind(this);
    this.renderLoading = this.renderLoading.bind(this);

    this.i18nPrefix = 'collections.share_modal.renew_link';

    this.state = {
      isRenewingLink: false
    };
  }

  onClick() {
    if (this.state.isRenewingLink) {
      return;
    }

    const self = this;

    this.setState({
      isRenewingLink: true
    });

    const url = `/collections/${this.props.collection.id}/sharing_config/renew-link.json`;
    const data = {};
    const config = {
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': ReactOnRails.authenticityToken()
      }
    };

    axios.post(url, data, config).
      then((response) => {
        // Update sharing config on collection
        const newCollection = self.props.collection;
        newCollection.sharing_config = response.data;
        self.props.setCollection(newCollection);

        self.setState({
          isRenewingLink: false
        });
      }).
      catch(() => {
        const id = `id${Math.random().toString(16).
          slice(2)}`;
        const content = I18n.t(`${self.i18nPrefix}.failure`);
        const notification = { id: id, content: content, type: 'error' };

        /*
         * HTML page is expected to have loaded the `<ActionNotifications />`
         * component separately
         */
        window.action_notifications.add(notification);

        self.setState({
          isRenewingLink: false
        });
      });
  }

  renderLink() {
    return <a data-testid="renew-link" onClick={this.onClick}>{I18n.t(`${this.i18nPrefix}.label`)}</a>;
  }

  renderLoading() {
    return <span className="loading">{I18n.t(`${this.i18nPrefix}.loading`)}</span>;
  }

  render() {
    return (
      <div className="share-collection__link-sharing-renew">
        {this.state.isRenewingLink ? this.renderLoading() : this.renderLink()}
      </div>
    );
  }

}

export default RenewLink;
