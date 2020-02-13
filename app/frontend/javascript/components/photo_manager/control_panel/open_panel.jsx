import {
  actionAddToCollection,
  actionClosePanel,
  actionRemoveFromCollection
} from './open_panel_actions';
import PropTypes from 'prop-types';
import React from 'react';
import SelectedPhotoCount from './selected_photo_count';

class OpenPanel extends React.Component {

  static propTypes = {
    /* eslint-disable react/no-unused-prop-types */
    collections: PropTypes.array.isRequired,
    currentCollection: PropTypes.object,
    updateCollections: PropTypes.func.isRequired,
    selectedPhotoIds: PropTypes.array.isRequired,

    ability: PropTypes.object.isRequired,

    closePanel: PropTypes.func.isRequired,
    afterAdditionToCollection: PropTypes.func.isRequired,
    afterRemovalFromCollection: PropTypes.func.isRequired
    /* eslint-enable react/no-unused-prop-types */
  };

  constructor(props) {
    super(props);

    this.renderSelectedPhotoCount = this.renderSelectedPhotoCount.bind(this);
  }

  renderSelectedPhotoCount() {
    return <SelectedPhotoCount count={this.props.selectedPhotoIds.length} />;
  }

  render() {
    return (
      <ul className="icon-tray photo-grid-control-panel__icon-tray--open">
        {actionClosePanel(this.props)}
        {this.renderSelectedPhotoCount()}
        {actionAddToCollection(this.props)}
        {actionRemoveFromCollection(this.props)}
      </ul>
    );
  }

}

export default OpenPanel;
