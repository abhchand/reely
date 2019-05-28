import CloseMenuButton from "./close_menu_button";
import DropdownMenu from "./dropdown_menu";
import OpenMenuButton from "./open_menu_button";
import PropTypes from "prop-types";
import React from "react";

class CreatableSelectDropdown extends React.Component {
  static propTypes = {
    options: PropTypes.array.isRequired,

    onCreate: PropTypes.func.isRequired,
    onSelect: PropTypes.func.isRequired,

    textForSearchInputPlaceholder: PropTypes.string,
    textForOptionsEmptyState: PropTypes.string,
    textForCloseMenuButton: PropTypes.string

  }

  constructor(props) {
    super(props);

    this.openMenu = this.openMenu.bind(this);
    this.closeMenu = this.closeMenu.bind(this);
    this.onCreate = this.onCreate.bind(this);
    this.onSelect = this.onSelect.bind(this);
    this.renderMenuClosed = this.renderMenuClosed.bind(this);
    this.renderMenuOpen = this.renderMenuOpen.bind(this);

    this.state = {
      menuOpen: false
    };
  }

  openMenu() {
    this.setState({
      menuOpen: true
    });
  }

  closeMenu() {
    this.setState({
      menuOpen: false
    });
  }

  onCreate(optionName) {
    this.props.onCreate(optionName);
    this.closeMenu();
  }

  onSelect(optionId) {
    this.props.onSelect(optionId);
    this.closeMenu();
  }

  renderMenuClosed() {
    return <OpenMenuButton openMenu={this.openMenu} />;
  }

  renderMenuOpen() {
    return (
      <div tabIndex={-1} className="creatable-select-dropdown-container">
        <CloseMenuButton
          closeMenu={this.closeMenu}
          label={this.props.textForCloseMenuButton} />

        <DropdownMenu
          options={this.props.options}
          closeMenu={this.closeMenu}
          handleSelect={this.onSelect}
          handleCreate={this.onCreate}
          textForSearchInputPlaceholder={this.props.textForSearchInputPlaceholder}
          textForOptionsEmptyState={this.props.textForOptionsEmptyState} />
      </div>
    );
  }

  render() {
    return this.state.menuOpen ? this.renderMenuOpen() : this.renderMenuClosed();
  }
}

export default CreatableSelectDropdown;
