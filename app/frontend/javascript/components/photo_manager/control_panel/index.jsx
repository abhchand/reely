import { keyCodes, parseKeyCode } from 'utils/keys';
import ClosedPanel from './closed_panel';
import OpenPanel from './open_panel';
import PropTypes from 'prop-types';
import React from 'react';

class ControlPanel extends React.Component {

  static propTypes = {
    collections: PropTypes.array.isRequired,
    currentCollection: PropTypes.object,
    updateCollections: PropTypes.func.isRequired,
    selectedPhotoIds: PropTypes.array.isRequired,

    ability: PropTypes.object.isRequired,

    onOpen: PropTypes.func.isRequired,
    onClose: PropTypes.func.isRequired,
    onRemovingFromCollection: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props);

    this.handleKeyDown = this.handleKeyDown.bind(this);
    this.onRemovingFromCollection = this.onRemovingFromCollection.bind(this);
    this.openPanel = this.openPanel.bind(this);
    this.closePanel = this.closePanel.bind(this);
    this.renderClosed = this.renderClosed.bind(this);
    this.renderOpen = this.renderOpen.bind(this);

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

  onRemovingFromCollection() {
    this.props.onRemovingFromCollection();
    this.closePanel();
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
      <ClosedPanel
        openPanel={this.openPanel}
        currentCollection={this.props.currentCollection}
        ability={this.props.ability} />
    );
  }

  renderOpen() {
    return (
      <OpenPanel
        collections={this.props.collections}
        currentCollection={this.props.currentCollection}
        updateCollections={this.props.updateCollections}
        selectedPhotoIds={this.props.selectedPhotoIds}
        ability={this.props.ability}
        closePanel={this.closePanel}
        afterAdditionToCollection={this.closePanel}
        afterRemovalFromCollection={this.onRemovingFromCollection} />
    );
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
