import PropTypes from "prop-types";
import React from "react";

const CloseMenuButton = (props) => {
  return (
    <div
      role="button"
      className="creatable-select-dropdown__close-menu-button"
      tabIndex={0}
      onClick={props.closeMenu}
      onKeyPress={props.closeMenu}>
      <span>{props.label}</span>
    </div>
  );
};

CloseMenuButton.propTypes = {
  closeMenu: PropTypes.func.isRequired,
  label: PropTypes.string
};

CloseMenuButton.defaultProps = {
  label: I18n.t("components.shared.creatable_select_dropdown_menu.close_menu_button.default_label")
};

export default CloseMenuButton;
