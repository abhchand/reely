import axios from 'axios';
import Modal from 'javascript/components/modal';
import ModalError from 'javascript/components/modal/error';
import React from 'react';
import ReactOnRails from 'react-on-rails/node_package/lib/Authenticity';

class ProductFeedbackForm extends React.Component {

  constructor(props) {
    super(props);

    this.renderErrorText = this.renderErrorText.bind(this);
    this.renderTextarea = this.renderTextarea.bind(this);
    this.onSubmit = this.onSubmit.bind(this);

    this.i18nPrefix = 'components.product_feedback_form';
    // This length should match model validation for `ProductFeedback`
    this.maxLength = 500;

    this.state = {
      errorText: null
    };

    this.textareaRef = React.createRef();
  }

  renderErrorText() {
    return this.state.errorText ? <ModalError text={this.state.errorText} /> : null;
  }

  renderTextarea() {
    return (
      <textarea
        className="product-feedback-form__textarea"
        name="product_feedback[body]"
        maxLength={this.maxLength}
        ref={this.textareaRef} />
    );
  }

  onSubmit() {
    const self = this;

    const url = '/product_feedbacks.json';
    // eslint-disable-next-line camelcase
    const data = { product_feedback: { body: this.textareaRef.current.value } };
    const config = {
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': ReactOnRails.authenticityToken()
      }
    };

    /*
     * NOTE: `<Modal>` component automatically closes the modal
     * after successful `onSubmit` and there's nothing else to
     * do here, so no need to specify a `then()`.
     */
    return axios.post(url, data, config).
      catch((error) => {
        self.setState({
          errorText: error.response.data.error
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
        heading={I18n.t(`${this.i18nPrefix}.heading`)}
        subheading={I18n.t(`${this.i18nPrefix}.subheading`, { maxlength: this.maxLength })}
        onSubmit={this.onSubmit}>
        {this.renderErrorText()}
        {this.renderTextarea()}
      </Modal>
    );
  }

}

export default ProductFeedbackForm;
