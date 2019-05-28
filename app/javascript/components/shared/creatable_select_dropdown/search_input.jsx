import PropTypes from "prop-types";
import React from "react";

class SearchInput extends React.Component {
  static propTypes = {
    options: PropTypes.array.isRequired,
    filteredOptions: PropTypes.array.isRequired,
    currentSelectedOptionIndex: PropTypes.number.isRequired,

    onChange: PropTypes.func.isRequired,

    onKeyEnter: PropTypes.func.isRequired,
    onKeyEscape: PropTypes.func.isRequired,
    onKeyArrowDown: PropTypes.func.isRequired,
    onKeyArrowUp: PropTypes.func.isRequired,

    placeholder: PropTypes.string
  };

  static defaultProps = {
    placeholder: I18n.t("components.shared.creatable_select_dropdown_menu.search_input.default_placeholder")
  }

  constructor(props) {
    super(props);

    this.onChange = this.onChange.bind(this);
    this.onKeyDown = this.onKeyDown.bind(this);
    this.performSearch = this.performSearch.bind(this);
  }

  onChange(e) {
    const query = e.target.value;
    const results = this.performSearch(query);

    this.props.onChange(query, results);
  }

  onKeyDown(e) {
    e.stopPropagation();

    switch(e.keyCode) {
      case 13: {
        // Enter
        const idx = this.props.currentSelectedOptionIndex;
        const id = this.props.filteredOptions[idx].id;
        this.props.onKeyEnter(id);
        break;
      }

      case 27: {
        // Escape
        this.props.onKeyEscape();
        break;
      }

      case 38: {
        // Up Arrow
        this.props.onKeyArrowUp();
        break;
      }

      case 40: {
        // Down Arrow
        this.props.onKeyArrowDown();
        break;
      }
    }
  }

  performSearch(_query) {
    const options = this.props.options;
    const results = [];

    const query = _query.trim();
    const regex = new RegExp(query, "i");

    for (let i = 0; i < options.length; i++) {

      const option = options[i];
      const name = option.name;

      // If user has not searched for anything
      if (query.length <= 0) {
        results.push({
          id: option.id,
          html: <span>{option.name}</span>
        });
        continue;
      }

      const match = option.name.match(regex);

      // If user has searched for something, and this option
      // is a match
      if (match) {

        const idxStart = name.toLowerCase().indexOf(query.toLowerCase());
        const idxEnd = idxStart + query.length - 1;

        const a = name.substring(0, idxStart);
        const b = name.substring(idxStart, idxEnd + 1);
        const c = name.substring(idxEnd + 1, name.length);

        results.push({
          id: option.id,
          html: <span>{a}<span className="highlight">{b}</span>{c}</span>
        });

      }
    }

    return results;
  }

  render() {
    return (
      <div className="creatable-select-dropdown-search-input">
        <input
          type="text"
          placeholder={this.props.placeholder}
          onChange={this.onChange}
          onKeyDown={this.onKeyDown} />
      </div>
    );
  }
}

export default SearchInput;
