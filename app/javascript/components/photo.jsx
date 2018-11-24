import {IconCheckMark} from "icons";
import PropTypes from "prop-types";
import React from "react";

class Photo extends React.Component {
  static propTypes = {
    photo: PropTypes.object.isRequired,
    photoIndex: PropTypes.number.isRequired,
    editModeEnabled: PropTypes.bool.isRequired,
    isSelected: PropTypes.bool.isRequired,
    handleClickWhenEditModeEnabled: PropTypes.func.isRequired,
    handleClickWhenEditModeDisabled: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props);

    this.photoUrl = this.photoUrl.bind(this);
    this.handleClick = this.handleClick.bind(this);
    this.renderOverlay = this.renderOverlay.bind(this);
    this.renderOverlayWhenEditModeEnabled = this.renderOverlayWhenEditModeEnabled.bind(this);
    this.renderOverlayWhenEditModeDisabled = this.renderOverlayWhenEditModeDisabled.bind(this);
  }

  photoUrl() {
    return this.props.photo.mediumUrl;
  }

  handleClick() {
    if (this.props.editModeEnabled) {
      this.props.handleClickWhenEditModeEnabled(this.props.photoIndex);
    } else {
      this.props.handleClickWhenEditModeDisabled(this.props.photoIndex);
    }
  }

  renderOverlay() {
    if (this.props.editModeEnabled) {
      return this.renderOverlayWhenEditModeEnabled();
    }
      return this.renderOverlayWhenEditModeDisabled();

  }

  renderOverlayWhenEditModeEnabled() {
    if (this.props.isSelected) {
      return (
        <div className="photo-grid__photo-selected-overlay">
          <IconCheckMark fillColor="#FFFFFF" />
        </div>
      );
    }
  }

  renderOverlayWhenEditModeDisabled() {
    return (
      <div className="photo-grid__photo-overlay">
        <span className="photo-grid__taken-at-label">
          {this.props.photo.takenAtLabel}
        </span>
      </div>
    );
  }

  render() {
    const divStyle = { backgroundImage: `url(${  this.photoUrl()  })` };
    const selectedClass = this.props.isSelected ? " selected" : "";

    return (
      <div
        data-id={this.props.photo.id}
        className={`photo-grid__photo-container${  selectedClass}`}
        onClick={this.handleClick}>

        <div className="photo-grid__photo covered-background" style={divStyle}>
          {this.renderOverlay()}
        </div>
      </div>
    );
  }
}

export default Photo;
