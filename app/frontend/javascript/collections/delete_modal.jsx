import axios from 'axios';
import Modal from 'javascript/components/modal';
import ModalError from 'javascript/components/modal/error';
import PropTypes from 'prop-types';
import React from 'react';
import ReactOnRails from 'react-on-rails/node_package/lib/Authenticity';

class DeleteCollectionModal extends React.Component {

  static propTypes = {
    collection: PropTypes.object.isRequired,
    onClose: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props);

    this.heading = this.heading.bind(this);
    this.errorText = this.errorText.bind(this);
    this.onSubmit = this.onSubmit.bind(this);

    this.i18nPrefix = 'collections.delete_modal';

    this.state = {
      submitButtonEnabled: true,
      errorText: null
    };
  }

  heading() {
    return I18n.t(
      `${this.i18nPrefix}.heading`,
      // eslint-disable-next-line camelcase
      { collection_name: this.props.collection.name }
    );
  }

  errorText() {
    return this.state.errorText ? <ModalError text={this.state.errorText} /> : null;
  }

  onSubmit() {
    const self = this;

    const url = `/collections/${this.props.collection.id}.json`;
    const config = {
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': ReactOnRails.authenticityToken()
      }
    };

    this.setState({
      submitButtonEnabled: false,
      errorText: null
    });

    return axios.delete(url, config).
      then((_response) => {
        // Redirect to index page
        window.location.href = '/collections';
      }).
      catch((error) => {
        // Re-enable submit
        this.setState({ submitButtonEnabled: true });

        // Display error
        self.setState({
          errorText: I18n.t('generic_error')
        });

        /*
         * Return a rejected value so the promise chain remains in
         * a rejected state
         */
        return Promise.reject(error);
      });
  }

  render() {
    return (
      <Modal
        heading={this.heading()}
        submitButtonLabel={I18n.t(`${this.i18nPrefix}.buttons.submit`)}
        onSubmit={this.onSubmit}
        onClose={this.props.onClose}
        submitButtonEnabled={this.state.submitButtonEnabled}>
        {this.errorText()}
        {I18n.t(`${this.i18nPrefix}.body`)}
      </Modal>
    );
  }

}

export default DeleteCollectionModal;
