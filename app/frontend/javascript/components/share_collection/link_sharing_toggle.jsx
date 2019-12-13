import axios from 'axios';
import PropTypes from 'prop-types';
import React from 'react';
import ReactOnRails from 'react-on-rails/node_package/lib/Authenticity';
import Switch from 'react-toggle-switch';

class LinkSharingToggle extends React.Component {

  static propTypes = {
    collection: PropTypes.object.isRequired,
    // eslint-disable-next-line react/no-unused-prop-types
    setCollection: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props);

    this.isEnabled = this.isEnabled.bind(this);
    this.label = this.label.bind(this);
    this.onClick = this.onClick.bind(this);

    this.i18nPrefix = 'components.share_collection.link_sharing_toggle';

    this.state = {
      isUpdating: false
    };
  }

  onClick() {
    const self = this;

    const newCollection = this.props.collection;
    const newState = !newCollection.sharing_config.via_link.enabled;

    this.setState({
      isUpdating: true
    });

    const url = `/collections/${this.props.collection.id}/sharing_config.json`;
    const data = { 'link_sharing_enabled': newState };
    const config = {
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': ReactOnRails.authenticityToken()
      }
    };

    axios.patch(url, data, config).
      then((response) => {
        // Update sharing config on collection
        const newCollection = self.props.collection;
        newCollection.sharing_config = response.data;
        self.props.setCollection(newCollection);

        self.setState({
          isUpdating: false
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
          isUpdating: false
        });
      });
  }

  isEnabled() {
    return this.props.collection.sharing_config.via_link.enabled;
  }

  label() {
    const i18nKey = this.isEnabled() ? 'enabled' : 'disabled';
    return I18n.t(`${this.i18nPrefix}.${i18nKey}`);
  }

  render() {
    // eslint-disable-next-line react/no-danger
    const labelContent = <span dangerouslySetInnerHTML={{ __html: this.label() }} />;

    return (
      <div data-testid="link-sharing-toggle" className="share-collection__link-sharing-toggle">
        <Switch
          onClick={this.onClick}
          on={this.isEnabled()}
          enabled={!this.state.isUpdating} />
        {labelContent}
      </div>
    );
  }

}

export default LinkSharingToggle;
