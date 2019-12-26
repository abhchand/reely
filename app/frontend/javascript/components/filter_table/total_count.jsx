import PropTypes from 'prop-types';
import React from 'react';

const TotalCount = (props) => {
  if (props.totalCount <= 0) { return null; }

  const i18nPrefix = 'components.filter_table.total_count';

  return (
    <div className="filter-table__total-count">
      { I18n.t(`${i18nPrefix}.heading`, { total: props.totalCount }) }
    </div>
  );
};

TotalCount.propTypes = {
  totalCount: PropTypes.number.isRequired
};

export default TotalCount;
