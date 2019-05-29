import {IconCheckMark} from "components/icons";
import PropTypes from "prop-types";
import React from "react";

const OpenButton = (props) => {
  return (
    <div
      role="button"
      tabIndex={0}
      className="photo-grid-control-panel__toggle-button photo-grid-control-panel__open-button"
      onClick={props.onClick}
      onKeyPress={props.onClick}>
      <IconCheckMark size="22" fillColor="#888888" />
    </div>
  );
};

OpenButton.propTypes = {
  onClick: PropTypes.func.isRequired
};

export default OpenButton;
