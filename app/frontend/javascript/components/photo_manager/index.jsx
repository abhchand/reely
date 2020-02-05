import ControlPanel from './control_panel';
import Empty from './empty';
import mountReactComponent from 'mount-react-component.jsx';
import PhotoCarousel from './carousel';
import PhotoGrid from './photo_grid';
import PropTypes from 'prop-types';
import React from 'react';

class PhotoManager extends React.Component {

  static propTypes = {
    photoData: PropTypes.array.isRequired,
    collections: PropTypes.array,
    currentCollection: PropTypes.object,
    isReadOnly: PropTypes.bool,
    allowAddingToCollection: PropTypes.bool,
    allowRemovingFromCollection: PropTypes.bool
  };

  static defaultProps = {
    collections: [],
    isReadOnly: false
  }

  constructor(props) {
    super(props);

    this.removeSelectedPhotos = this.removeSelectedPhotos.bind(this);
    this.updateCollections = this.updateCollections.bind(this);
    this.updateSelectedPhotoIds = this.updateSelectedPhotoIds.bind(this);
    this.enableSelectionMode = this.enableSelectionMode.bind(this);
    this.disableSelectionMode = this.disableSelectionMode.bind(this);
    this.enableCarousel = this.enableCarousel.bind(this);
    this.disableCarousel = this.disableCarousel.bind(this);
    this.renderControlPanel = this.renderControlPanel.bind(this);
    this.renderPhotoGrid = this.renderPhotoGrid.bind(this);
    this.renderCarousel = this.renderCarousel.bind(this);

    this.state = {
      photoData: this.props.photoData,
      collections: this.props.collections,
      showCarousel: false,
      selectionModeEnabled: false,
      selectedPhotoIds: []
    };
  }

  removeSelectedPhotos() {
    this.setState((prevState) => {
      const idsToRemove = prevState.selectedPhotoIds;
      const newPhotoData = prevState.photoData.filter((photo) => idsToRemove.indexOf(photo.id) < 0);

      return { photoData: newPhotoData };
    });
  }

  updateCollections(newCollections) {
    this.setState((_prevState) => {
      return { collections: newCollections };
    });
  }

  updateSelectedPhotoIds(newSelectedPhotoIds) {
    this.setState((_prevState) => {
      return { selectedPhotoIds: newSelectedPhotoIds };
    });
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
        collections={this.state.collections}
        currentCollection={this.props.currentCollection}
        updateCollections={this.updateCollections}
        selectedPhotoIds={this.state.selectedPhotoIds}
        onOpen={this.enableSelectionMode}
        onClose={this.disableSelectionMode}
        isReadOnly={this.props.isReadOnly}
        allowAddingToCollection={this.props.allowAddingToCollection}
        allowRemovingFromCollection={this.props.allowRemovingFromCollection}
        onRemovingFromCollection={this.removeSelectedPhotos} />
    );
  }

  renderPhotoGrid() {
    return (
      <PhotoGrid
        photoData={this.state.photoData}
        onClick={this.enableCarousel}
        selectionModeEnabled={this.state.selectionModeEnabled}
        selectedPhotoIds={this.state.selectedPhotoIds}
        updateSelectedPhotoIds={this.updateSelectedPhotoIds} />
    );
  }

  renderCarousel() {
    if (this.state.showCarousel) {
      return (
        <PhotoCarousel
          photoData={this.state.photoData}
          clickedPhotoIndex={this.state.clickedPhotoIndex}
          closeCarousel={this.disableCarousel} />
      );
    }
  }

  render() {
    const enabledClass = this.state.selectionModeEnabled ? ' photo-grid--selection-mode-enabled' : '';

    if (this.state.photoData.length === 0) {
      return <Empty />;
    }

    return (
      <div className={`photo-manager${enabledClass}`} tabIndex="-1" role="presentation">
        {this.renderControlPanel()}
        {this.renderPhotoGrid()}
        {this.renderCarousel()}
      </div>
    );
  }

}

export default PhotoManager;

mountReactComponent(PhotoManager, 'photo-manager');
