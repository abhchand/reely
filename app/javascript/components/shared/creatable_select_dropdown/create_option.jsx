import {parseKeyCode} from "utils";
import PropTypes from "prop-types";
import React from "react";

class CreateOption extends React.Component {
  static propTypes = {
    searchInputValue: PropTypes.string.isRequired,
    onClick: PropTypes.func.isRequired,
    labelGenerator: PropTypes.func
  };

  static defaultProps = {
    labelGenerator: (text) => ( `Create '${text}'` )
  }

  constructor(props) {
    super(props);

    this.onClick = this.onClick.bind(this);
    this.onKeyDown = this.onKeyDown.bind(this);
  }

  // eslint-disable-next-line no-unused-vars
  onClick(_e) {
    const optionName = this.props.searchInputValue.trim();
    this.props.onClick(optionName);
  }

  onKeyDown(e) {
    switch(parseKeyCode(e)) {
      case 13:
        // Enter
        this.onClick(e);
        break;
    }
  }

  render() {
    const optionName = this.props.searchInputValue.trim();

    if (optionName.length <= 0) {
      return null;
    }

    return(
      <div
        data-testid="create-option"
        role="button"
        tabIndex={0}
        className="creatable-select-dropdown-create-option"
        onClick={this.onClick}
        onKeyDown={this.onKeyDown}>
        <span>{this.props.labelGenerator(optionName)}</span>
      </div>
    );
  }
}

export default CreateOption;
