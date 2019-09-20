import axios from "axios";
import LinkSharing from "./link_sharing";
import LoadingIconEllipsis from "components/shared/icons/loading_icon_ellipsis";
import ModalError from "components/shared/modal_error";
import PropTypes from "prop-types";
import React from "react";
import ReactOnRails from "react-on-rails/node_package/lib/Authenticity";

class ShareCollection extends React.Component {
  static propTypes = {
    collection: PropTypes.object.isRequired
  }

  constructor(props) {
    super(props);

    this.setCollection = this.setCollection.bind(this);
    this.renderHeading = this.renderHeading.bind(this);
    this.renderLinkSharing = this.renderLinkSharing.bind(this);

    this.i18nPrefix = "components.share_collection.share_collection";

    this.state = {
      isLoading: true,
      fetchFailed: false,
      collection: this.props.collection
    };
  }

  componentDidMount() {
    const self = this;

    const url = `/collections/${  this.props.collection.id  }/sharing_config.json`;
    const data = {};
    const config = {
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": ReactOnRails.authenticityToken()
      }
    };

    axios.get(url, data, config)
      .then(function(response) {
        // Update sharing config on collection
        const newCollection = self.state.collection;
        newCollection.sharing_config = response.data;
        self.setCollection(newCollection);

        self.setState({
          isLoading: false
        });
      })
      .catch(function() {
        self.setState({
          fetchFailed: true,
          isLoading: false
        });
      })
    ;
  }

  setCollection(newCollection) {
    this.setState({
      collection: newCollection
    });
  }

  renderHeading() {
    return (
      <h1 key="share-collection__heading" className="share-collection__heading">
        {I18n.t(`${this.i18nPrefix  }.heading`, { name: this.props.collection.name })}
      </h1>
    );
  }

  renderLinkSharing() {
    return (<LinkSharing
      key="share-collection__link-sharing"
      collection={this.state.collection}
      setCollection={this.setCollection} />);
  }

  render() {
    if (this.state.isLoading) {
      return <LoadingIconEllipsis className={"share-collection__loading-icon"} />;
    }

    if (this.state.fetchFailed) {
      return <ModalError />;
    }

    return([
      this.renderHeading(),
      this.renderLinkSharing()
    ]);
  }
}

export default ShareCollection;
