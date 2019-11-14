import { IconCheckMark } from 'components/icons';
import PropTypes from 'prop-types';
import React from 'react';

const OpenButton = (props) => {
  return (
    <li
      tabIndex={0}
      className="icon-tray__item icon-tray__item--open-control-panel"
      onClick={props.onClick}
      onKeyPress={props.onClick}>
      <IconCheckMark size="24" fillColor="#888888" />
    </li>
  );
};

OpenButton.propTypes = {
  onClick: PropTypes.func.isRequired
};

export default OpenButton;
