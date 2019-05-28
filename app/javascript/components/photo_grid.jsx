import ControlPanel from "./photo_grid/control_panel/control_panel";
import Photo from "photo";
import PhotoCarousel from "photo_carousel";
import PhotoSelectionService from "./services/photo_selection_service";
import PropTypes from "prop-types";
import React from "react";

class PhotoGrid extends React.Component {
  static propTypes = {
    photoData: PropTypes.array.isRequired,
    collections: PropTypes.array.isRequired
  }

  constructor(props) {
    super(props);

    this.enableSelectionMode = this.enableSelectionMode.bind(this);
    this.disableSelectionMode = this.disableSelectionMode.bind(this);
    this.handlePhotoSelection = this.handlePhotoSelection.bind(this);
    this.enableCarousel = this.enableCarousel.bind(this);
    this.disableCarousel = this.disableCarousel.bind(this);
    this.renderControlPanel = this.renderControlPanel.bind(this);
    this.renderPhoto = this.renderPhoto.bind(this);
    this.renderCarousel = this.renderCarousel.bind(this);

    this.state = {
      showCarousel: false,
      selectionModeEnabled: false,
      selectedPhotoIds: []
    };
  }

  enableSelectionMode() {
    this.setState({
      selectionModeEnabled: true
    });
  }

  disableSelectionMode() {
    this.setState({
      selectionModeEnabled: false,
      selectedPhotoIds: []
    });
  }

  handlePhotoSelection(photoIndex, event) {
    const self = this;

    this.setState(function(prevState) {
      const service = new PhotoSelectionService(
        self.props.photoData,
        prevState.selectedPhotoIds,
        photoIndex,
        event
      );

      service.performSelection();

      return { selectedPhotoIds: service.selectedPhotoIds };
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

  renderControlPanel() {
    return (
      <ControlPanel
        collections={this.props.collections}
        selectedPhotoIds={this.state.selectedPhotoIds}
        onOpen={this.enableSelectionMode}
        onClose={this.disableSelectionMode} />
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

        {this.renderControlPanel()}

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
