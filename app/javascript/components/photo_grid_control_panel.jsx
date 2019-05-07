import PhotoGridSelectionToggle from "photo_grid_selection_toggle";
import PropTypes from "prop-types";
import React from "react";

// eslint-disable-next-line react/prop-types
class PhotoGridControlPanel extends React.Component {
  static propTypes = {
    selectionModeEnabled: PropTypes.bool.isRequired,
    toggleSelectionMode: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props);

    this.renderPhotoGridControlPanel = this.renderPhotoGridControlPanel.bind(this);
  }

  renderPhotoGridControlPanel() {
    return (
      <PhotoGridSelectionToggle
        selectionModeEnabled={this.props.selectionModeEnabled}
        toggleSelectionMode={this.props.toggleSelectionMode} />
    );
  }

  render() {
    return this.renderPhotoGridControlPanel();
  }
}

export default PhotoGridControlPanel;
