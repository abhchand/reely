import PropTypes from 'prop-types';
import React from 'react';

const Url = (props) => {
  return (
    <input
      data-testid='url-input'
      className='share-collection__url'
      value={props.collection.sharing_config.via_link.url}
      readOnly
    />
  );
};

Url.propTypes = {
  collection: PropTypes.object.isRequired
};

Url.defaultProps = {};

export default Url;
