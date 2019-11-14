import { keyCodes, parseKeyCode } from 'utils/keys';
import AddToCollection from './actions/add_to_collection';
import CloseButton from './actions/close_button';
import OpenButton from './actions/open_button';
import PropTypes from 'prop-types';
import React from 'react';
import SelectedPhotoCount from './selected_photo_count';

class ControlPanel extends React.Component {

  static propTypes = {
    collections: PropTypes.array.isRequired,
    updateCollections: PropTypes.func.isRequired,
    selectedPhotoIds: PropTypes.array.isRequired,

    onOpen: PropTypes.func.isRequired,
    onClose: PropTypes.func.isRequired,

    isReadOnly: PropTypes.bool.isRequired,
    allowAddingToCollection: PropTypes.bool
  };

  static defaultProps = {
    allowAddingToCollection: true
  }

  constructor(props) {
    super(props);

    this.handleKeyDown = this.handleKeyDown.bind(this);
    this.openPanel = this.openPanel.bind(this);
    this.closePanel = this.closePanel.bind(this);
    this.renderClosed = this.renderClosed.bind(this);
    this.renderOpen = this.renderOpen.bind(this);
    this.renderAddToCollection = this.renderAddToCollection.bind(this);

    this.state = {
      isOpen: false
    };
  }

  handleKeyDown(e) {
    switch (parseKeyCode(e)) {
      case keyCodes.ESCAPE: {
        if (this.state.isOpen) {
          this.closePanel();
        }
        break;
      }

      // eslint skip default
    }
  }

  openPanel() {
    this.setState({
      isOpen: true
    });
    this.props.onOpen();
  }

  closePanel() {
    this.setState({
      isOpen: false
    });

    this.props.onClose();
  }

  renderClosed() {
    return (
      <ul key="controlPanelIconTray" className="icon-tray">
        <OpenButton onClick={this.openPanel} />
      </ul>
    );
  }

  renderOpen() {
    return [
      <ul key="controlPanelIconTray" className="icon-tray">
        <CloseButton onClick={this.closePanel} />
        {this.renderAddToCollection()}
      </ul>,
      <SelectedPhotoCount
        key="controlPanelSelectedPhotoCount"
        count={this.props.selectedPhotoIds.length} />
    ];
  }

  renderAddToCollection() {
    if (!this.props.isReadOnly && this.props.allowAddingToCollection) {
      return (
        <AddToCollection
          collections={this.props.collections}
          updateCollections={this.props.updateCollections}
          selectedPhotoIds={this.props.selectedPhotoIds}
          onAddToExistingCollection={this.closePanel} />
      );
    }

    return null;
  }

  render() {
    const content = this.state.isOpen ? this.renderOpen() : this.renderClosed();
    const state = this.state.isOpen ? 'open' : 'closed';

    return (
      <div
        role="presentation"
        className={`photo-grid-control-panel photo-grid-control-panel--${state}`}
        onKeyDown={this.handleKeyDown}>
        {content}
      </div>
    );
  }

}

export default ControlPanel;