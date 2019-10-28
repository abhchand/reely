import AddToCollection from "./add_to_collection";
import PropTypes from "prop-types";
import React from "react";

class BulkActionPanel extends React.Component {
  static propTypes = {
    collections: PropTypes.array.isRequired,
    selectedPhotoIds: PropTypes.array.isRequired,
    closeControlPanel: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props);
  }

  render() {
    return (
      <ul className="photo_grid-bulk-action-panel">
        <AddToCollection
          collections={this.props.collections}
          selectedPhotoIds={this.props.selectedPhotoIds}
          onAddToExistingCollection={this.props.closeControlPanel} />
      </ul>
    );
  }
}

export default BulkActionPanel;
