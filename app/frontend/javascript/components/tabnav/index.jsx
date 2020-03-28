import PropTypes from 'prop-types';
import React from 'react';

class Tabnav extends React.Component {

  static propTypes = {
    tabLabels: PropTypes.array.isRequired,
    currentTabIndex: PropTypes.number.isRequired,
    onClick: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props);

    this.onClick = this.onClick.bind(this);
    this.classModifierFor = this.classModifierFor.bind(this);
  }

  onClick(e) {
    const index = parseInt(e.currentTarget.dataset.id, 10);
    this.props.onClick(index);
  }

  classModifierFor(index) {
    return index === this.props.currentTabIndex ? 'active' : '';
  }

  render() {
    const tabs = [];

    for (let n = 0; n < this.props.tabLabels.length; n++) {
      // eslint-disable-next-line function-paren-newline
      tabs.push(
        <li key={`tab-${n}`} className="tabnav__tab">
          <button data-id={n} className={this.classModifierFor(n)} type="button" onClick={this.onClick}>
            {this.props.tabLabels[n]}
          </button>
        </li>
      // eslint-disable-next-line function-paren-newline
      );
    }

    return <ul className="tabnav">{tabs}</ul>;
  }

}

export default Tabnav;
