import axios from 'axios';
import Error from './error';
import Loading from './loading';
import Pagination from './pagination';
import PropTypes from 'prop-types';
import React from 'react';
import ReactOnRails from 'react-on-rails/node_package/lib/Authenticity';
import SearchInput from './search_input';
import Table from './table';
import TotalCount from './total_count';

class FilterTable extends React.Component {

  static propTypes = {
    items: PropTypes.array.isRequired,
    // eslint-disable-next-line react/no-unused-prop-types
    updateItems: PropTypes.func.isRequired,

    tableHeader: PropTypes.node.isRequired,
    tableBody: PropTypes.node.isRequired,

    fetchUrl: PropTypes.string.isRequired,
    containerClass: PropTypes.string
  };

  static defaultProps = {
    containerClass: ''
  }

  constructor(props) {
    super(props);

    this.fetchItems = this.fetchItems.bind(this);
    this.renderContent = this.renderContent.bind(this);
    this.performSearch = this.performSearch.bind(this);
    this.updatePage = this.updatePage.bind(this);

    this.i18nPrefix = 'components.filter_table';

    this.state = {
      currentPage: 1,
      currentSearch: '',
      totalPages: 0,
      // eslint-disable-next-line react/no-unused-state
      totalItems: 0,
      isLoading: true,
      fetchFailed: false
    };
  }

  componentDidMount() {
    const params = {
      page: this.state.currentPage,
      search: this.state.currentSearch
    };

    this.fetchItems(params);
  }

  fetchItems(params) {
    const self = this;

    const url = this.props.fetchUrl;
    const config = {
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRF-Token': ReactOnRails.authenticityToken()
      },
      params: params
    };

    axios.get(url, config).
      then((response) => {
        self.setState({
          totalItems: response.data.total_items,
          currentPage: params.page,
          totalPages: response.data.total_pages,
          currentSearch: params.search,
          isLoading: false,
          fetchFailed: false
        });

        self.props.updateItems(response.data.items);
      }).
      catch((_error) => {
        self.setState({
          totalItems: null,
          currentPage: 1,
          totalPages: null,
          currentSearch: params.search,
          isLoading: false,
          fetchFailed: true
        });

        self.props.updateItems([]);
      });
  }

  performSearch(searchString) {
    // We reset the page every time we update the search
    this.fetchItems({ page: 1, search: searchString });
  }

  updatePage(newPage) {
    if (newPage >= 1 && newPage <= this.state.totalPages) {
      this.fetchItems({ page: newPage, search: this.state.currentSearch });
    }
  }

  renderContent() {
    if (this.state.fetchFailed) { return <Error />; }
    if (this.state.isLoading) { return <Loading />; }

    return [
      <div key="filter-table__pagination-bar" className="filter-table__pagination-bar">
        <TotalCount totalCount={this.state.totalItems} />
        <Pagination
          currentPage={this.state.currentPage}
          totalPages={this.state.totalPages}
          updatePage={this.updatePage} />
      </div>,
      <Table
        key="filter-table__table"
        thead={this.props.tableHeader}
        tbody={this.props.tableBody}
        itemCount={this.props.items.length} />
    ];
  }

  render() {
    return (
      <div className={`filter-table ${this.props.containerClass}`}>
        <div className="filter-table__action-bar">
          <SearchInput performSearch={this.performSearch} />
        </div>
        {this.renderContent()}
      </div>
    );
  }

}

export default FilterTable;
