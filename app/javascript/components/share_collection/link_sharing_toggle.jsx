import PropTypes from "prop-types";
import React from "react";
import Switch from "react-toggle-switch";

class RenewLink extends React.Component {
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

    this.i18nPrefix = "components.share_collection.link_sharing_toggle";

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

    $.ajax({
      type: "PUT",
      url: `/collections/${  this.props.collection.id  }/sharing_config`,
      dataType: "json",
      data: JSON.stringify({ "link_sharing_enabled": newState }),
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
          isUpdating: false
        });
      })
      .done(function(data) {
        // Update sharing config on collection
        const newCollection = self.props.collection;
        newCollection.sharing_config = data;
        self.props.setCollection(newCollection);

        self.setState({
          isUpdating: false
        });
      })
    ;
  }

  isEnabled() {
    return this.props.collection.sharing_config.via_link.enabled;
  }

  label() {
    const i18nKey = this.isEnabled() ? "enabled" : "disabled";
    return I18n.t(`${this.i18nPrefix  }.${  i18nKey}`);
  }

  render() {
    // eslint-disable-next-line react/no-danger
    const labelContent = <span dangerouslySetInnerHTML={{__html: this.label()}}></span>;

    return (
      <div className="share-collection__link-sharing-toggle">
        <Switch
          onClick={this.onClick}
          on={this.isEnabled()}
          enabled={!this.state.isUpdating} />
        {labelContent}
      </div>
    );
  }
}

export default RenewLink;
