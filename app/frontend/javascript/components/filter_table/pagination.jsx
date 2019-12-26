/* eslint-disable camelcase */
import { IconArrowThickLeft, IconArrowThickRight } from 'components/icons';
import PropTypes from 'prop-types';
import React from 'react';

class Pagination extends React.Component {

  static propTypes = {
    currentPage: PropTypes.number.isRequired,
    totalPages: PropTypes.number.isRequired,
    updatePage: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props);

    this.jumpToPage = this.jumpToPage.bind(this);
    this.jumpToPrevPage = this.jumpToPrevPage.bind(this);
    this.jumpToNextPage = this.jumpToNextPage.bind(this);
    this.renderPrevLink = this.renderPrevLink.bind(this);
    this.renderNextLink = this.renderNextLink.bind(this);
    this.renderPageLinks = this.renderPageLinks.bind(this);

    this.i18nPrefix = 'components.filter_table.pagination';
    this.pageNavWindowSize = 5;
  }

  jumpToPage(e) {
    // NOTE: `updatePage` handles range validation
    this.props.updatePage(parseInt(e.currentTarget.dataset.id, 10));
  }

  jumpToPrevPage() {
    // NOTE: `updatePage` handles range validation
    this.props.updatePage(this.props.currentPage - 1);
  }

  jumpToNextPage() {
    // NOTE: `updatePage` handles range validation
    this.props.updatePage(this.props.currentPage + 1);
  }

  renderPrevLink() {
    const btnClass = this.props.currentPage === 1 ? 'inactive' : '';

    return (
      <li className="filter-table__pagination-nav-link filter-table__pagination-nav-link--prev">
        <button className={btnClass} type="button" onClick={this.jumpToPrevPage}>
          <IconArrowThickLeft size="24" fillColor="#00335D" />
        </button>
      </li>
    );
  }

  renderNextLink() {
    const btnClass = this.props.currentPage === this.props.totalPages ? 'inactive' : '';

    return (
      <li className="filter-table__pagination-nav-link filter-table__pagination-nav-link--next">
        <button className={btnClass} type="button" onClick={this.jumpToNextPage}>
          <IconArrowThickRight size="24" fillColor="#00335D" />
        </button>
      </li>
    );
  }

  renderPageLinks() {
    const currentPage = this.props.currentPage;
    const totalPages = this.props.totalPages;
    const pages = [];

    const min = Math.max(currentPage - this.pageNavWindowSize, 1);
    const max = Math.min(currentPage + this.pageNavWindowSize, totalPages);

    for (let n = min; n <= max; n++) {
      const currentClass = n === currentPage ? 'current' : '';

      // eslint-disable-next-line function-paren-newline
      pages.push(
        <li key={`page-link-${n}`} className="filter-table__pagination-page-link">
          <button type="button" data-id={n} className={currentClass} onClick={this.jumpToPage}>
            {n}
          </button>
        </li>
      // eslint-disable-next-line function-paren-newline
      );
    }

    return pages;
  }

  render() {
    if (this.props.totalPages <= 1) { return null; }

    return (
      <ul className="filter-table__pagination">
        {this.renderPrevLink()}
        {this.renderPageLinks()}
        {this.renderNextLink()}
      </ul>
    );
  }

}

export default Pagination;
