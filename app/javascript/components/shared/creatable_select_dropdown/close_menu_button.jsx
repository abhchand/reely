import {parseKeyCode} from "utils";
import PropTypes from "prop-types";
import React from "react";


const CloseMenuButton = (props) => {
  return (
    <div
      data-testid="close-menu-button"
      role="button"
      className="creatable-select-dropdown__close-menu-button"
      tabIndex={0}
      onClick={props.onClick}
      onKeyPress={(e) => { if (parseKeyCode(e) === 13 /* Enter */) { props.onClick(e); } }}>
      <span>{props.label}</span>
    </div>
  );
};

CloseMenuButton.propTypes = {
  onClick: PropTypes.func.isRequired,
  label: PropTypes.string
};

CloseMenuButton.defaultProps = {
  label: "Close"
};

export default CloseMenuButton;
