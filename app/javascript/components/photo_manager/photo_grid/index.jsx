import Photo from './photo';
import PhotoSelectionService from './photo_selection_service';
import PropTypes from 'prop-types';
import React from 'react';

class PhotoGrid extends React.Component {

  static propTypes = {
    photoData: PropTypes.array.isRequired,
    onClick: PropTypes.func.isRequired,
    selectionModeEnabled: PropTypes.bool.isRequired,
    selectedPhotoIds: PropTypes.array.isRequired,
    updateSelectedPhotoIds: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props);

    this.handlePhotoSelection = this.handlePhotoSelection.bind(this);
  }

  handlePhotoSelection(photoIndex, event) {
    event.persist();

    const service = new PhotoSelectionService(
      this.props.photoData,
      this.props.selectedPhotoIds,
      photoIndex,
      event
    );

    service.performSelection();
    this.props.updateSelectedPhotoIds(service.selectedPhotoIds);
  }

  render() {
    return (
      <div className="photo-grid">
        {
          this.props.photoData.map((photo, photoIndex) => {
            return (
              <Photo
                key={`photo_${photo.id}`}
                photo={photo}
                photoIndex={photoIndex}
                selectionModeEnabled={this.props.selectionModeEnabled}
                isSelected={this.props.selectedPhotoIds.indexOf(photo.id) >= 0}
                handleClickWhenSelectionModeEnabled={this.handlePhotoSelection}
                handleClickWhenSelectionModeDisabled={this.props.onClick} />
            );
          })
        }
      </div>
    );
  }
}

export default PhotoGrid;
