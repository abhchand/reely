import OpenButton from './actions/open_button';
import PropTypes from 'prop-types';
import React from 'react';

class ClosedPanel extends React.Component {

  static propTypes = {
    openPanel: PropTypes.func.isRequired
  };

  constructor(props) {
    super(props);

    this.renderActions = this.renderActions.bind(this);
  }

  renderActions() {
    return (
      <ul className="icon-tray">
        <OpenButton onClick={this.props.openPanel} />
      </ul>
    );
  }

  render() {
    return this.renderActions();
  }

}

export default ClosedPanel;
