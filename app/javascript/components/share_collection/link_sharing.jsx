import CopyLink from "./copy_link";
import LinkSharingToggle from "./link_sharing_toggle";
import PropTypes from "prop-types";
import React from "react";
import RenewLink from "./renew_link";
import Url from "./url";

class LinkSharing extends React.Component {
  static propTypes = {
    collection: PropTypes.object.isRequired,
    setCollection: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props);

    this.isEnabled = this.isEnabled.bind(this);
    this.renderCopyLink = this.renderCopyLink.bind(this);
    this.renderRenewLink = this.renderRenewLink.bind(this);
    this.renderContent = this.renderContent.bind(this);
  }

  isEnabled() {
    return this.props.collection.sharing_config.via_link.enabled;
  }

  renderCopyLink() {
    return this.isEnabled() ? <CopyLink /> : null;
  }

  renderRenewLink() {
    if (!this.isEnabled()) {
      return null;
    }

    return (
      <RenewLink
        collection={this.props.collection}
        setCollection={this.props.setCollection} />
    );
  }

  renderContent() {
    if (!this.isEnabled()) {
      return null;
    }

    return (
      <div className="share-collection__link-sharing-content">
        <Url collection={this.props.collection} />

        <div className="share-collection__link-sharing-actions">
          {this.renderCopyLink()}
          {this.renderRenewLink()}
        </div>
      </div>
    );
  }

  render() {
    return (
      <div className="share-collection__link-sharing">
        <LinkSharingToggle
          collection={this.props.collection}
          setCollection={this.props.setCollection} />

        {this.renderContent()}
      </div>
    );
  }
}

export default LinkSharing;
