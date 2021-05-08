import axios from 'axios';
import dataStore from 'javascript/models';
import ReactOnRails from 'react-on-rails/node_package/lib/Authenticity';

/*
 * Fetches data from an API endpoint via GET.
 *
 * If the dataset is paginated, multiple parallel requests will
 * be made to fetch the data.
 *
 * The data is loaded and saved into the dataStore for further
 * retrieval
 */

const PER_PAGE = 25;

const parse = (jsonApiResponse) => {
  dataStore.sync(jsonApiResponse);
};

const fetchPage = (url, page, perPage) => {
  const config = {
    headers: {
      'Content-Type': 'application/json',
      Accept: 'application/json',
      'X-CSRF-Token': ReactOnRails.authenticityToken()
    },
    params: {
      page: page || 1,
      per_page: perPage || PER_PAGE
    }
  };

  return axios.get(url, config);
};

const apiGet = (url, opts = {}) => {
  /*
   * We don't know beforehand how many pages of data
   * will need to be fetched.
   *
   * So we fetch only 1 page to begin with, whose response
   * should contain a "total count" of records to be fetched.
   *
   * If more pages exist, we create parallel requests to
   * fetch the other pages.
   *
   * Any fetched data is stored in the dataStore
   */
  return fetchPage(url, 1, opts.perPage)
    .then((response) => {
      parse(response.data);

      // Determine the total number of pages to fetch
      if (response.data.meta && response.data.meta.totalCount) {
        return Math.ceil(response.data.meta.totalCount / PER_PAGE);
      }

      return 1;
    })
    .then((totalPages) => {
      // If only one page needed to be fetched, exit now
      if (totalPages <= 1) {
        return [];
      }

      // Otherwise, fetch the remaining pages in parallel
      const requests = [];
      for (let p = 2; p <= totalPages; p++) {
        requests.push(fetchPage(url, p, opts.perPage));
      }

      return Promise.all(requests);
    })
    .then((responses) => {
      responses.forEach((response) => parse(response));
    });
};

export default apiGet;
