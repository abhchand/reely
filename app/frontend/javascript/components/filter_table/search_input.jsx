import { os } from 'javascript/utils/os';
import PropTypes from 'prop-types';
import React from 'react';

class SearchInput extends React.Component {

  static propTypes = {
    performSearch: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props);

    this.onChange = this.onChange.bind(this);

    this.i18nPrefix = 'components.filter_table.search_input';
  }

  onChange(e) {
    const searchString = e.currentTarget.value;
    this.props.performSearch(searchString);
  }

  render() {
    const meta_key = I18n.t(`${this.i18nPrefix}.meta_key.${os()}`);

    return (
      <input
        className="filter-table__search-input"
        type="text"
        name="search"
        autoComplete="off"
        placeholder={I18n.t(`${this.i18nPrefix}.placeholder`, { meta_key: meta_key })}
        onChange={this.onChange} />
    );
  }

}

export default SearchInput;
