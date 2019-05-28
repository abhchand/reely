import {IconX} from "icons";
import PropTypes from "prop-types";
import React from "react";

const CloseButton = (props) => {
  return (
    <div
      role="button"
      tabIndex={0}
      className="photo-grid-control-panel__toggle-button photo-grid-control-panel__close-button"
      onClick={props.onClick}
      onKeyPress={props.onClick}>
      <IconX size="22" fillColor="#888888" />
    </div>
  );
};

CloseButton.propTypes = {
  onClick: PropTypes.func.isRequired
};

export default CloseButton;
