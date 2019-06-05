import CreateOption from "./create_option";
import PropTypes from "prop-types";
import React from "react";
import SearchInput from "./search_input";
import SelectOptions from "./select_options";

class DropdownMenu extends React.Component {
  static propTypes = {
    options: PropTypes.array.isRequired,

    closeMenu: PropTypes.func.isRequired,
    handleSelect: PropTypes.func.isRequired,
    handleCreate: PropTypes.func.isRequired,

    textForOptionsEmptyState: PropTypes.string,
    textForSearchInputPlaceholder: PropTypes.string,
    textGeneratorForCreateOption: PropTypes.func
  }

  constructor(props) {
    super(props);

    this.updateSearchResults = this.updateSearchResults.bind(this);
    this.incrementSelectedOption = this.incrementSelectedOption.bind(this);
    this.decrementSelectedOption = this.decrementSelectedOption.bind(this);

    this.state = {
      searchInputValue: "",
      filteredOptions: this.props.options,
      currentSelectedOptionIndex: 0,
    };
  }

  updateSearchResults(query, results) {
    this.setState({
      searchInputValue: query,
      filteredOptions: results,
      currentSelectedOptionIndex: 0
    });
  }

  incrementSelectedOption() {
    this.setState(function(prevState) {
      let idx = prevState.currentSelectedOptionIndex;

      if (idx < (prevState.filteredOptions.length - 1)) {
        idx += 1;
      }

      return { currentSelectedOptionIndex: idx };
    });
  }

  decrementSelectedOption() {
    this.setState(function(prevState) {
      let idx = prevState.currentSelectedOptionIndex;

      if (idx > 0) {
        idx -= 1;
      }

      return { currentSelectedOptionIndex: idx };
    });
  }

  render() {
    return (
      <div data-testid="dropdown-menu" className="creatable-select-dropdown-menu">
        <SearchInput
          options={this.props.options}
          filteredOptions={this.state.filteredOptions}
          currentSelectedOptionIndex={this.state.currentSelectedOptionIndex}
          onChange={this.updateSearchResults}
          onKeyEnter={this.props.handleSelect}
          onKeyEscape={this.props.closeMenu}
          onKeyArrowDown={this.incrementSelectedOption}
          onKeyArrowUp={this.decrementSelectedOption}
          placeholder={this.props.textForSearchInputPlaceholder} />

        <SelectOptions
          options={this.state.filteredOptions}
          currentSelectedOptionIndex={this.state.currentSelectedOptionIndex}
          onClick={this.props.handleSelect}
          textForEmptyState={this.props.textForOptionsEmptyState} />

        <CreateOption
          searchInputValue={this.state.searchInputValue}
          onClick={this.props.handleCreate}
          labelGenerator={this.props.textGeneratorForCreateOption} />
      </div>
    );
  }
}

export default DropdownMenu;
