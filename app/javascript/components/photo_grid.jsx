import Photo from "photo";
import PhotoCarousel from "photo_carousel";
import PhotoGridControlPanel from "photo_grid_control_panel";
import PhotoSelectionService from "./services/photo_selection_service";
import PropTypes from "prop-types";
import React from "react";

class PhotoGrid extends React.Component {
  static propTypes = {
    photoData: PropTypes.array.isRequired
  }

  constructor(props) {
    super(props);

    this.toggleSelectionMode = this.toggleSelectionMode.bind(this);
    this.handleKeyDown = this.handleKeyDown.bind(this);
    this.handlePhotoSelection = this.handlePhotoSelection.bind(this);
    this.enableCarousel = this.enableCarousel.bind(this);
    this.disableCarousel = this.disableCarousel.bind(this);
    this.renderPhotoGridControlPanel = this.renderPhotoGridControlPanel.bind(this);
    this.renderPhoto = this.renderPhoto.bind(this);
    this.renderCarousel = this.renderCarousel.bind(this);

    this.state = {
      showCarousel: false,
      selectionModeEnabled: false,
      currentPhotoIndex: null,
      selectedPhotoIds: []
    };
  }

  handleKeyDown(e) {
    switch(e.keyCode) {
      case 27:
        // Escape
        if (this.state.selectionModeEnabled) {
          this.toggleSelectionMode();
        }
        break;
    }
  }

  toggleSelectionMode() {
    this.setState({
      selectionModeEnabled: !this.state.selectionModeEnabled,
      selectedPhotoIds: []
    });
  }

  handlePhotoSelection(photoIndex, event) {
    const service = new PhotoSelectionService(
      this.props.photoData,
      this.state.selectedPhotoIds,
      photoIndex,
      event
    );

    service.performSelection();

    this.setState({
      selectedPhotoIds: service.selectedPhotoIds
    });
  }

  enableCarousel(photoIndex) {
    if (photoIndex !== null) {
      this.setState({
        showCarousel: true,
        clickedPhotoIndex: photoIndex
      });
    }
  }

  disableCarousel() {
    this.setState({
      showCarousel: false,
      clickedPhotoIndex: null
    });
  }

  renderPhotoGridControlPanel() {
    return (
      <PhotoGridControlPanel
        selectionModeEnabled={this.state.selectionModeEnabled}
        toggleSelectionMode={this.toggleSelectionMode} />
    );
  }

  renderPhoto(photo, photoIndex) {
    return (
      <Photo
        key={`photo_${photo.id}`}
        photo={photo}
        photoIndex={photoIndex}
        selectionModeEnabled={this.state.selectionModeEnabled}
        isSelected={this.state.selectedPhotoIds.indexOf(photo.id) >= 0}
        handleClickWhenSelectionModeEnabled={this.handlePhotoSelection}
        handleClickWhenSelectionModeDisabled={this.enableCarousel} />
    );
  }

  renderCarousel() {
    if (this.state.showCarousel) {
      return (
        <PhotoCarousel
          photoData={this.props.photoData}
          clickedPhotoIndex={this.state.clickedPhotoIndex}
          closeCarousel={this.disableCarousel}/>
      );
    }
  }

  render() {
    const self = this;
    const enabledClass = (this.state.selectionModeEnabled ? " photo-grid--selection-mode-enabled" : "");

    return (
      <div
        className={`photo-grid${  enabledClass}`}
        onKeyDown={this.handleKeyDown}
        tabIndex="-1"
        role="presentation">

        {this.renderPhotoGridControlPanel()}

        <div className="photo-grid__content">
          {
            this.props.photoData.map(function(photo, photoIndex){
              return self.renderPhoto(photo, photoIndex);
            })
          }
        </div>

        {this.renderCarousel()}
      </div>
    );
  }
}

export default PhotoGrid;
