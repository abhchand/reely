import { IconCheckMark } from 'components/icons';
import PropTypes from 'prop-types';
import React from 'react';

const OpenButton = (props) => {
  return (
    <li className="icon-tray__item icon-tray__item--open-control-panel">
      <button type="button" onClick={props.onClick}>
        <IconCheckMark size="20" fillColor="#888888" />
      </button>
    </li>
  );
};

OpenButton.propTypes = {
  onClick: PropTypes.func.isRequired
};

export default OpenButton;
