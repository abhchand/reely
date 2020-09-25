import { IconShare } from 'components/icons';
import PropTypes from 'prop-types';
import React from 'react';
import ShareCollectionModal from 'javascript/collections/share_modal';

class ShareCollection extends React.Component {
  static propTypes = {
    collection: PropTypes.object.isRequired
  };

  constructor(props) {
    super(props);

    this.toggleModal = this.toggleModal.bind(this);
    this.renderModal = this.renderModal.bind(this);

    this.state = {
      isModalOpen: false
    };
  }

  toggleModal() {
    this.setState((prevState) => {
      const { isModalOpen } = prevState;
      return { isModalOpen: !isModalOpen };
    });
  }

  renderModal() {
    if (!this.state.isModalOpen) {
      return null;
    }

    return (
      <ShareCollectionModal
        collection={this.props.collection}
        onClose={this.toggleModal}
      />
    );
  }

  render() {
    return (
      <li className='icon-tray__item icon-tray__item--share-collection'>
        <button type='button' onClick={this.toggleModal}>
          <IconShare size='20' fillColor='#888888' />
        </button>
        {this.renderModal()}
      </li>
    );
  }
}

export default ShareCollection;
