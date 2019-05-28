import PropTypes from "prop-types";
import React from "react";

class CreateOption extends React.Component {
  static propTypes = {
    searchInputValue: PropTypes.string.isRequired,
    onClick: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props);

    this.onClick = this.onClick.bind(this);
    this.onKeyDown = this.onKeyDown.bind(this);
    this.formatText = this.formatText.bind(this);
  }

  onClick() {
    const optionName = this.props.searchInputValue.trim();
    this.props.onClick(optionName);
  }

  onKeyDown(e) {
    switch(e.keyCode) {
      case 13:
        // Enter
        this.onClick();
        break;
    }
  }

  formatText(text) {
    return (
      I18n.t(
        "components.shared.creatable_select_dropdown_menu.create_option.label",
        { name: text }
      )
    );
  }

  render() {
    const optionName = this.props.searchInputValue.trim();

    if (optionName.length <= 0) {
      return null;
    }

    return(
      <div
        role="button"
        tabIndex={0}
        className="creatable-select-dropdown-create-option"
        onClick={this.onClick}
        onKeyDown={this.onKeyDown}>
        <span>{this.formatText(optionName)}</span>
      </div>
    );
  }
}

export default CreateOption;
