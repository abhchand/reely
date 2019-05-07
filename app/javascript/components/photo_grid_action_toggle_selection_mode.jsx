import {IconCheckMark} from "icons";
import PropTypes from "prop-types";
import React from "react";

// eslint-disable-next-line react/prop-types
const PhotoGridActionToggleSelectionMode = (props) => {
  const fillColor = (props.selectionModeEnabled ? "#FFFFFF" : "#888888");

  return (
    <div
      role="button"
      tabIndex={0}
      className="photo-grid__selection-toggle"
      onClick={props.toggleSelectionMode}
      onKeyPress={props.toggleSelectionMode}>
      <IconCheckMark size="22" fillColor={fillColor} />
    </div>
  );
};

PhotoGridActionToggleSelectionMode.propTypes = {
  selectionModeEnabled: PropTypes.bool.isRequired,
  toggleSelectionMode: PropTypes.func.isRequired
};

export default PhotoGridActionToggleSelectionMode;
