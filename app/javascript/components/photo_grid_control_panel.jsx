import PhotoGridActionToggleSelectionMode from "./photo_grid_action_toggle_selection_mode";
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
      <PhotoGridActionToggleSelectionMode
        selectionModeEnabled={this.props.selectionModeEnabled}
        toggleSelectionMode={this.props.toggleSelectionMode} />
    );
  }

  render() {
    return this.renderPhotoGridControlPanel();
  }
}

export default PhotoGridControlPanel;
