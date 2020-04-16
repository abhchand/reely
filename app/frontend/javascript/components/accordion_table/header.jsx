import PropTypes from 'prop-types';
import React from 'react';

const Header = (props) => {
  return (
    <div className="accordion-table-header">
      {props.renderContent()}
    </div>
  );
};

Header.propTypes = {
  renderContent: PropTypes.func.isRequired
};

export default Header;
