import axios from 'axios';
import LinkSharing from './link_sharing';
import LoadingIconEllipsis from 'components/icons/loading_icon_ellipsis';
import Modal from 'javascript/components/modal';
import ModalError from 'javascript/components/modal/error';
import PropTypes from 'prop-types';
import React from 'react';
import ReactOnRails from 'react-on-rails/node_package/lib/Authenticity';

class ShareCollection extends React.Component {

  static propTypes = {
    collection: PropTypes.object.isRequired
  }

  constructor(props) {
    super(props);

    this.setCollection = this.setCollection.bind(this);
    this.renderLinkSharing = this.renderLinkSharing.bind(this);

    this.i18nPrefix = 'components.share_collection.share_collection';

    this.state = {
      isLoading: true,
      fetchFailed: false,
      collection: this.props.collection
    };
  }

  componentDidMount() {
    const self = this;

    const url = `/collections/${this.props.collection.id}/sharing_config.json`;
    const data = {};
    const config = {
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': ReactOnRails.authenticityToken()
      }
    };

    axios.get(url, data, config).
      then((response) => {
        // Update sharing config on collection
        const newCollection = self.state.collection;
        // eslint-disable-next-line camelcase
        newCollection.sharing_config = response.data;
        self.setCollection(newCollection);

        self.setState({
          isLoading: false
        });
      }).
      catch(() => {
        self.setState({
          fetchFailed: true,
          isLoading: false
        });
      });
  }

  setCollection(newCollection) {
    this.setState({
      collection: newCollection
    });
  }

  renderLinkSharing() {
    return (
      <LinkSharing
        collection={this.state.collection}
        setCollection={this.setCollection} />
    );
  }

  render() {
    let content;

    if (this.state.isLoading) {
      content = <LoadingIconEllipsis className="share-collection__loading-icon" />;
    }
    else if (this.state.fetchFailed) {
      content = <ModalError />;
    }
    else {
      content = this.renderLinkSharing();
    }

    return (
      <Modal heading={I18n.t(`${this.i18nPrefix}.heading`, { name: this.props.collection.name })} >
        {content}
      </Modal>
    );
  }

}

export default ShareCollection;
