import PropTypes from "prop-types";
import React from "react";

const LoadingIconEllipsis = (props) => {
  return (
    <div className={`loading-icon loading-icon--ellipsis ${props.className}`}>
      <div></div>
      <div></div>
      <div></div>
      <div></div>
    </div>
  );
};

LoadingIconEllipsis.propTypes = {
  className: PropTypes.string
};

LoadingIconEllipsis.defaultProps = {
  className: ""
};

export default LoadingIconEllipsis;
