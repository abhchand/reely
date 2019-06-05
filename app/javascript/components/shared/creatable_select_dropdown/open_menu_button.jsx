import {IconPlus} from "components/icons";
import {parseKeyCode} from "utils";
import PropTypes from "prop-types";
import React from "react";

// eslint-disable-next-line react/prop-types
const OpenMenuButton = (props) => {
  return (
    <div
      data-testid="open-menu-button"
      role="button"
      className="creatable-select-dropdown__open-menu-button"
      tabIndex={0}
      onClick={props.onClick}
      onKeyPress={(e) => { if (parseKeyCode(e) === 13 /* Enter */) { props.onClick(e); } }}>
      <IconPlus size="22" fillColor={"#4F14C8"} />
    </div>
  );
};

OpenMenuButton.propTypes = {
  onClick: PropTypes.func.isRequired
};

export default OpenMenuButton;
