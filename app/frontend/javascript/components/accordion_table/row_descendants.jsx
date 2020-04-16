import PropTypes from 'prop-types';
import React from 'react';

const RowDescendants = (props) => {
  const { ancestor, renderContent } = props;

  return (
    <div className="accordion-table-row-descendants">
      {renderContent(ancestor)}
    </div>
  );
};

RowDescendants.propTypes = {
  ancestor: PropTypes.object.isRequired,
  renderContent: PropTypes.func.isRequired
};

export default RowDescendants;
