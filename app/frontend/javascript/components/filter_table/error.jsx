import React from 'react';

const Loading = (_props) => {
  return (
    <div className='filter-table--fetch-error'>{I18n.t('generic_error')}</div>
  );
};

export default Loading;
