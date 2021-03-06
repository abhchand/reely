import {
  actionDeleteCollection,
  actionDownloadCollection,
  actionOpenPanel,
  actionShareCollection
} from './closed_panel_actions';
import PropTypes from 'prop-types';
import React from 'react';

class ClosedPanel extends React.Component {
  static propTypes = {
    /* eslint-disable react/no-unused-prop-types */
    openPanel: PropTypes.func.isRequired,
    currentCollection: PropTypes.object,
    ability: PropTypes.object.isRequired
    /* eslint-enable react/no-unused-prop-types */
  };

  render() {
    return (
      <ul className='icon-tray photo-grid-control-panel__icon-tray--closed'>
        {actionOpenPanel(this.props)}
        {actionShareCollection(this.props)}
        {actionDownloadCollection(this.props)}
        {actionDeleteCollection(this.props)}
      </ul>
    );
  }
}

export default ClosedPanel;
