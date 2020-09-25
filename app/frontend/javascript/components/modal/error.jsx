import PropTypes from 'prop-types';
import React from 'react';

const ModalError = (props) => {
  return <div className='modal--error'>{props.text}</div>;
};

ModalError.propTypes = {
  text: PropTypes.string
};

ModalError.defaultProps = {
  text: I18n.t('generic_error')
};

export default ModalError;
