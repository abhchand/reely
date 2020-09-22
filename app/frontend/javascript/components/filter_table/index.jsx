import { registerAsyncProcess, unregisterAsyncProcess } from 'utils/async-registration';

import axios from 'axios';
import dataStore from 'javascript/models';
import Error from './error';
import Loading from './loading';
import Pagination from './pagination';
import PropTypes from 'prop-types';
import React from 'react';
import ReactOnRails from 'react-on-rails/node_package/lib/Authenticity';
import SearchInput from './search_input';
import Table from './table';
import TotalCount from './total_count';

import './focus-search-on-keypress';

class FilterTable extends React.Component {

  static propTypes = {
    renderHeader: PropTypes.func.isRequired,
    renderBody: PropTypes.func.isRequired,
    refreshAt: PropTypes.number,

    fetchUrl: PropTypes.string.isRequired,
    containerClass: PropTypes.string,
    mapResponseDataToItems: PropTypes.func
  };

  static defaultProps = {
    containerClass: '',
    mapResponseDataToItems: (data, _dataStore) => dataStore.sync(data)
  };

  // eslint-disable-next-line padded-blocks
  static getDerivedStateFromProps(props, state) {

    /*
     * If the parent passes in a `refreshAt` prop
     * that's more recent than our latest refresh, then
     * trigger a refresh. This functionality allows any
     * parent component an easy way force a data
     * refresh here.
     */

    if (state.lastRefreshedAt !== null &&
      props.refreshAt !== null &&
      props.refreshAt > state.lastRefreshedAt) {
      return { shouldRefresh: true };
    }

    return null;
  }

  constructor(props) {
    super(props);

    this.fetchItems = this.fetchItems.bind(this);
    this.renderContent = this.renderContent.bind(this);
    this.refresh = this.refresh.bind(this);
    this.performSearch = this.performSearch.bind(this);
    this.updatePage = this.updatePage.bind(this);

    this.i18nPrefix = 'components.filter_table';

    this.state = {
      displayedItems: [],
      currentPage: 1,
      currentSearch: '',
      totalPages: 0,
      // eslint-disable-next-line react/no-unused-state
      totalItems: 0,
      isLoading: true,
      fetchFailed: false,
      lastRefreshedAt: null,
      shouldRefresh: true
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

    registerAsyncProcess('filter-table-fetch-items');

    axios.get(url, config).
      then((response) => {
        const collection = response.data;
        const pageParam = (collection.links.last || '').match(/page=(\d+)/i) || [null, 0];
        const displayedItems = self.props.mapResponseDataToItems(collection, dataStore);

        self.setState({
          displayedItems: displayedItems,
          totalItems: collection.meta.totalCount,
          currentPage: params.page,
          totalPages: parseInt(pageParam[1], 10),
          currentSearch: params.search,
          isLoading: false,
          fetchFailed: false,
          lastRefreshedAt: Date.now(),
          shouldRefresh: false
        });

        unregisterAsyncProcess('filter-table-fetch-items');
      }).
      catch((_error) => {
        self.setState({
          displayedItems: [],
          totalItems: null,
          currentPage: 1,
          totalPages: null,
          currentSearch: params.search,
          isLoading: false,
          fetchFailed: true,
          lastRefreshedAt: Date.now(),
          shouldRefresh: false
        });

        unregisterAsyncProcess('filter-table-fetch-items');
      });
  }

  refresh() {
    this.fetchItems({ page: 1, search: '' });
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
        thead={this.props.renderHeader(this.state.displayedItems)}
        tbody={this.props.renderBody(this.state.displayedItems)}
        itemCount={this.state.displayedItems.length} />
    ];
  }

  render() {
    if (this.state.shouldRefresh) {
      this.refresh();
    }

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
