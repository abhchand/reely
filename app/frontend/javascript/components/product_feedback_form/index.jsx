import axios from 'axios';
import React from 'react';
import ReactOnRails from 'react-on-rails/node_package/lib/Authenticity';

class ProductFeedbackForm extends React.Component {

  constructor(props) {
    super(props);

    this.renderHeading = this.renderHeading.bind(this);
    this.renderSubheading = this.renderSubheading.bind(this);
    this.renderErrorText = this.renderErrorText.bind(this);
    this.renderTextarea = this.renderTextarea.bind(this);
    this.renderSubmit = this.renderSubmit.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);

    this.i18nPrefix = 'components.product_feedback_form';
    // This length should match model validation for `ProductFeedback`
    this.maxLength = 500;

    this.state = {
      errorText: null
    };

    this.textareaRef = React.createRef();
  }

  renderHeading() {
    return (
      <h1 key="product-feedback-form__heading" className="product-feedback-form__heading">
        {I18n.t(`${this.i18nPrefix}.heading`)}
      </h1>
    );
  }

  renderSubheading() {
    return (
      <h3 key="product-feedback-form__subheading" className="product-feedback-form__subheading">
        {I18n.t(`${this.i18nPrefix}.subheading`, { maxlength: this.maxLength })}
      </h3>
    );
  }

  renderErrorText() {
    return (
      <div
        key="modal-content__error"
        className="modal-content__error">
        {this.state.errorText}
      </div>
    );
  }

  renderTextarea() {
    return (
      <textarea
        key="product-feedback-form__textarea"
        className="product-feedback-form__textarea"
        name="product_feedback[body]"
        maxLength={this.maxLength}
        ref={this.textareaRef} />
    );
  }

  renderSubmit() {
    return (
      <input
        key="product-feedback-form__submit"
        className="modal-content__button modal-content__button--submit cta cta-purple"
        value={I18n.t(`${this.i18nPrefix}.submit`)}
        type="button"
        onClick={this.handleSubmit} />
    );
  }

  handleSubmit() {
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

    axios.post(url, data, config).
      then((_response) => {

        /*
         * TBD: Close modal
         * TBD: Update spec
         */
      }).
      catch((error) => {
        self.setState({
          errorText: error.response.data.error
        });
      });
  }

  render() {
    return [
      this.renderHeading(),
      this.renderSubheading(),
      this.renderErrorText(),
      this.renderTextarea(),
      this.renderSubmit()
    ];
  }

}

export default ProductFeedbackForm;
