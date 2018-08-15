var PhotoGrid = React.createClass({
  propTypes:{
    photoData: React.PropTypes.array.isRequired
  },

  getInitialState: function() {
    return {
      showCarousel: false,
      editModeEnabled: false,
      currentPhotoIndex: null,
      selectedPhotoIds: []
    }
  },

  toggleEditMode: function() {
    console.log("Toggle Edit Mode");

    this.setState({
      editModeEnabled: !this.state.editModeEnabled,
      selectedPhotoIds: []
    });
  },

  togglePhotoSelection: function(photoIndex) {
    var selectedPhotoIds = this.state.selectedPhotoIds;
    var photoId = this.props.photoData[photoIndex].id;

    if (selectedPhotoIds.includes(photoId)) {
      // Unselect photo by removing it from array
      var index = selectedPhotoIds.indexOf(photoId);
      if (index !== -1) selectedPhotoIds.splice(index, 1);
    } else {
      // Select photo by adding it to array
      selectedPhotoIds.push(photoId);
    }

    this.setState({
      selectedPhotoIds: selectedPhotoIds
    });
  },

  enableCarousel: function(photoIndex) {
    if (photoIndex !== null) {
      this.setState({
        showCarousel: true,
        clickedPhotoIndex: photoIndex
      });
    }
  },

  disableCarousel: function(e) {
    this.setState({
      showCarousel: false,
      clickedPhotoIndex: null
    });
  },

  renderEditToggle: function() {
    return (
      <PhotoGridEditToggle
        editModeEnabled={this.state.editModeEnabled}
        toggleEditMode={this.toggleEditMode} />
    );
  },

  renderPhoto: function(photo, photoIndex) {
    return (
      <Photo
        key={`photo_${photo.id}`}
        photo={photo}
        photoIndex={photoIndex}
        editModeEnabled={this.state.editModeEnabled}
        isSelected={this.state.selectedPhotoIds.includes(photo.id)}
        handleClickWhenEditModeEnabled={this.togglePhotoSelection}
        handleClickWhenEditModeDisabled={this.enableCarousel} />
    );
  },

  renderCarousel: function() {
    if (this.state.showCarousel) {
      return (
        <PhotoCarousel
          photoData={this.props.photoData}
          clickedPhotoIndex={this.state.clickedPhotoIndex}
          closeCarousel={this.disableCarousel}/>
      );
    }
  },

  render: function() {
    var self = this;
    var enabledClass = (this.state.editModeEnabled ? " photo-grid--edit-mode-enabled" : "");

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
});
