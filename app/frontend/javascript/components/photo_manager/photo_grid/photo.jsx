import { IconCheckMark } from 'components/icons';
import PropTypes from 'prop-types';
import React from 'react';

class Photo extends React.Component {

  static propTypes = {
    photo: PropTypes.object.isRequired,
    photoIndex: PropTypes.number.isRequired,
    selectionModeEnabled: PropTypes.bool.isRequired,
    isSelected: PropTypes.bool.isRequired,
    handleClickWhenSelectionModeEnabled: PropTypes.func.isRequired,
    handleClickWhenSelectionModeDisabled: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props);

    this.photoUrl = this.photoUrl.bind(this);
    this.applyRotation = this.applyRotation.bind(this);
    this.applyAntiRotation = this.applyAntiRotation.bind(this);
    this.handleClick = this.handleClick.bind(this);
    this.renderOverlay = this.renderOverlay.bind(this);
    this.renderOverlayWhenSelectionModeEnabled = this.renderOverlayWhenSelectionModeEnabled.bind(this);
    this.renderOverlayWhenSelectionModeDisabled = this.renderOverlayWhenSelectionModeDisabled.bind(this);
  }

  photoUrl() {
    return this.props.photo.mediumUrl;
  }

  applyRotation(style) {
    const degrees = this.props.photo.rotate || 0;

    if (degrees === 0) {
      return;
    }

    style.transform = `rotate(${degrees}deg)`;
  }

  applyAntiRotation(style) {

    /*
     * Child elements get rotated along with the parent and can't be
     * reversed using `transform: none`. Apply an anti-rotation to
     * correct the orientation of all child elements
     */

    const degrees = this.props.photo.rotate || 0;

    if (degrees === 0) {
      return;
    }

    style.transform = `rotate(${-1 * degrees}deg)`;
  }

  handleClick(e) {
    if (this.props.selectionModeEnabled) {
      this.props.handleClickWhenSelectionModeEnabled(this.props.photoIndex, e);
    }
    else {
      this.props.handleClickWhenSelectionModeDisabled(this.props.photoIndex);
    }
  }

  renderOverlay() {
    if (this.props.selectionModeEnabled) {
      return this.renderOverlayWhenSelectionModeEnabled();
    }
    return this.renderOverlayWhenSelectionModeDisabled();
  }

  renderOverlayWhenSelectionModeEnabled() {
    const divStyle = {};
    this.applyAntiRotation(divStyle);

    if (this.props.isSelected) {
      return (
        <div className="photo-grid-photo__selected-overlay" style={divStyle}>
          <IconCheckMark fillColor="#FFFFFF" />
        </div>
      );
    }
  }

  renderOverlayWhenSelectionModeDisabled() {
    const divStyle = {};
    this.applyAntiRotation(divStyle);

    return (
      <div className="photo-grid-photo__overlay" style={divStyle}>
        <span className="photo-grid-photo__taken-at-label">
          {this.props.photo.takenAtLabel}
        </span>
      </div>
    );
  }

  render() {
    const divStyle = { backgroundImage: `url(${this.photoUrl()})` };
    const selectedClass = this.props.isSelected ? ' selected' : '';

    this.applyRotation(divStyle);

    return (
      <div
        data-id={this.props.photo.id}
        className={`photo-grid-photo__container${selectedClass}`}
        onClick={this.handleClick}>

        <div className="photo-grid-photo covered-background" style={divStyle}>
          {this.renderOverlay()}
        </div>
      </div>
    );
  }

}

export default Photo;
