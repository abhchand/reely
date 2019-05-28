import {IconPlus} from "icons";

import PropTypes from "prop-types";
import React from "react";

// eslint-disable-next-line react/prop-types
const OpenMenuButton = (props) => {
  return (
    <div
      role="button"
      className="creatable-select-dropdown__open-menu-button"
      tabIndex={0}
      onClick={props.openMenu}
      onKeyPress={props.openMenu}>
      <IconPlus size="22" fillColor={"#4F14C8"} />
    </div>
  );
};

OpenMenuButton.propTypes = {
  openMenu: PropTypes.func.isRequired
};

export default OpenMenuButton;
