import {IconCheckMark} from "icons";
import PropTypes from "prop-types";
import React from "react";

class PhotoGridEditToggle extends React.Component {
  static propTypes = {
    editModeEnabled: PropTypes.bool.isRequired,
    toggleEditMode: PropTypes.func.isRequired
  }

  render() {
    const fillColor = (this.props.editModeEnabled ? "#FFFFFF" : "#888888");

    return (
      <div
        className="photo-grid__edit-toggle"
        onClick={this.props.toggleEditMode}>
        <IconCheckMark size="22" fillColor={fillColor} />
      </div>
    );
  }
}

export default PhotoGridEditToggle;
