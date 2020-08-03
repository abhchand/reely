import { metaKeyLabel } from 'javascript/utils/keys';
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
    return (
      <input
        className="filter-table__search-input"
        type="text"
        name="search"
        autoComplete="off"
        placeholder={I18n.t(`${this.i18nPrefix}.placeholder`, { meta_key: metaKeyLabel() })}
        onChange={this.onChange} />
    );
  }

}

export default SearchInput;
