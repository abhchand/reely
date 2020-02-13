import DeleteCollectionModal from 'javascript/collections/delete_modal';
import { IconTrash } from 'components/icons';
import PropTypes from 'prop-types';
import React from 'react';

class DeleteCollection extends React.Component {

  static propTypes = {
    collection: PropTypes.object.isRequired
  }

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

    return <DeleteCollectionModal collection={this.props.collection} onClose={this.toggleModal} />;
  }

  render() {
    return (
      <li className="icon-tray__item icon-tray__item--delete-collection">
        <button type="button" onClick={this.toggleModal}>
          <IconTrash size="18" fillColor="#888888" />
        </button>
        {this.renderModal()}
      </li>
    );
  }

}

export default DeleteCollection;
