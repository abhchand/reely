import PropTypes from "prop-types";
import React from "react";

import PhotoGridEditToggle from "photo_grid_edit_toggle";
import PhotoCarousel from "photo_carousel";
import Photo from "photo";

class PhotoGrid extends React.Component {
  static propTypes = {
    photoData: PropTypes.array.isRequired
  }

  constructor(props) {
    super(props);

    this.toggleEditMode = this.toggleEditMode.bind(this);
    this.togglePhotoSelection = this.togglePhotoSelection.bind(this);
    this.enableCarousel = this.enableCarousel.bind(this);
    this.disableCarousel = this.disableCarousel.bind(this);
    this.renderEditToggle = this.renderEditToggle.bind(this);
    this.renderPhoto = this.renderPhoto.bind(this);
    this.renderCarousel = this.renderCarousel.bind(this);

    this.state = {
      showCarousel: false,
      editModeEnabled: false,
      currentPhotoIndex: null,
      selectedPhotoIds: []
    }
  }

  toggleEditMode() {
    console.log("Toggle Edit Mode");

    this.setState({
      editModeEnabled: !this.state.editModeEnabled,
      selectedPhotoIds: []
    });
  }

  togglePhotoSelection(photoIndex) {
    const selectedPhotoIds = this.state.selectedPhotoIds;
    const photoId = this.props.photoData[photoIndex].id;

    if (selectedPhotoIds.indexOf(photoId) >= 0) {
      // Unselect photo by removing it from array
      let index = selectedPhotoIds.indexOf(photoId);
      if (index !== -1) selectedPhotoIds.splice(index, 1);
    } else {
      // Select photo by adding it to array
      selectedPhotoIds.push(photoId);
    }

    this.setState({
      selectedPhotoIds: selectedPhotoIds
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

  disableCarousel(e) {
    this.setState({
      showCarousel: false,
      clickedPhotoIndex: null
    });
  }

  renderEditToggle() {
    return (
      <PhotoGridEditToggle
        editModeEnabled={this.state.editModeEnabled}
        toggleEditMode={this.toggleEditMode} />
    );
  }

  renderPhoto(photo, photoIndex) {
    return (
      <Photo
        key={`photo_${photo.id}`}
        photo={photo}
        photoIndex={photoIndex}
        editModeEnabled={this.state.editModeEnabled}
        isSelected={this.state.selectedPhotoIds.indexOf(photo.id) >= 0}
        handleClickWhenEditModeEnabled={this.togglePhotoSelection}
        handleClickWhenEditModeDisabled={this.enableCarousel} />
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
    const enabledClass = (this.state.editModeEnabled ? " photo-grid--edit-mode-enabled" : "");

    return (
      <div className={"photo-grid" + enabledClass}>
        {this.renderEditToggle()}

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
