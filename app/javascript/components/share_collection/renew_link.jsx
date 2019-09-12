import {IconRefresh} from "components/icons";
import PropTypes from "prop-types";
import React from "react";

class RenewLink extends React.Component {
  static propTypes = {
    collection: PropTypes.object.isRequired,
    // eslint-disable-next-line react/no-unused-prop-types
    setCollection: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props);

    this.onClick = this.onClick.bind(this);
    this.renderButtonContents = this.renderButtonContents.bind(this);
    this.renderLoading = this.renderLoading.bind(this);

    this.i18nPrefix = "components.share_collection.renew_link";

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

    $.ajax({
      type: "POST",
      url: `/collections/${  this.props.collection.id  }/sharing_config/renew-link`,
      dataType: "json",
      contentType: "application/json"
    })
      .fail(function() {
        const id = `id${  Math.random().toString(16).slice(2)}`;
        const content = I18n.t(`${self.i18nPrefix  }.failure`);
        const notification = { id: id, content: content, type: "error" };

        // HTML page is expected to have loaded the `<ActionNotifications />`
        // component separately
        window.action_notifications.add(notification);

        self.setState({
          isRenewingLink: false
        });
      })
      .done(function(data) {
        // Update sharing config on collection
        const newCollection = self.props.collection;
        newCollection.sharing_config = data;
        self.props.setCollection(newCollection);

        self.setState({
          isRenewingLink: false
        });
      })
    ;
  }

  renderButtonContents() {
    return (
      <div className="button-contents">
        <IconRefresh size="22px" fillColor="#000000" />
        <span>{I18n.t(`${this.i18nPrefix  }.label`)}</span>
      </div>
    );
  }

  renderLoading() {
    return (
      <div className="button-contents loading">
        <IconRefresh size="22px" fillColor="#888888" />
        <span>{I18n.t(`${this.i18nPrefix  }.loading`)}</span>
      </div>
    );
  }

  render() {
    return (
      <button type="button" className="share-collection__link-sharing-renew" onClick={this.onClick}>
        {this.state.isRenewingLink ? this.renderLoading() : this.renderButtonContents()}
      </button>
    );
  }
}

export default RenewLink;
