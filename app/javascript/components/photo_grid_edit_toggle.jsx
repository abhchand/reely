import {IconCheckMark} from "icons";
import PropTypes from "prop-types";
import React from "react";

// eslint-disable-next-line react/prop-types
const PhotoGridEditToggle = (props) => {
  const fillColor = (props.editModeEnabled ? "#FFFFFF" : "#888888");

  return (
    <div
      role="button"
      tabIndex={0}
      className="photo-grid__edit-toggle"
      onClick={props.toggleEditMode}
      onKeyPress={props.toggleEditMode}>
      <IconCheckMark size="22" fillColor={fillColor} />
    </div>
  );
};

PhotoGridEditToggle.propTypes = {
  editModeEnabled: PropTypes.bool.isRequired,
  toggleEditMode: PropTypes.func.isRequired
};

export default PhotoGridEditToggle;
