import { IconHalfArrowRight } from 'components/icons';
import PropTypes from 'prop-types';
import React from 'react';
import RowDescendants from './row_descendants';

class Row extends React.Component {

  static propTypes = {
    data: PropTypes.object.isRequired,
    type: PropTypes.string.isRequired,
    renderContent: PropTypes.func.isRequired,
    renderDescendants: PropTypes.func
  };

  constructor(props) {
    super(props);

    this.onClick = this.onClick.bind(this);
    this.expand = this.expand.bind(this);
    this.collapse = this.collapse.bind(this);
    this.renderArrow = this.renderArrow.bind(this);
    this.renderRow = this.renderRow.bind(this);
    this.renderDescendants = this.renderDescendants.bind(this);

    this.i18nPrefix = 'components.accordion_table.row';

    this.state = {
      isExpanded: false
    };
  }

  onClick() {
    const { isExpanded } = this.state;

    isExpanded ? this.collapse() : this.expand();
  }

  expand() {
    if (!this.props.renderDescendants) {
      return;
    }

    this.setState({
      isExpanded: true
    });
  }

  collapse() {
    this.setState({
      isExpanded: false
    });
  }

  renderArrow() {
    if (!this.props.renderDescendants) {
      return null;
    }

    let className = '';
    const { isExpanded } = this.state;

    if (isExpanded) {
      className = 'accordion-table-row__expand-arrow--expanded';
    }

    return (
      <button
        type="button"
        className={`accordion-table-row__expand-arrow ${className}`}
        onClick={this.onClick}>
        <IconHalfArrowRight
          size="14"
          fillColor="#888888"
          title={I18n.t(`${this.i18nPrefix}.arrow_title`)} />
      </button>
    );
  }

  renderRow() {
    const { data, renderContent, type } = this.props;

    return (
      <div
        key={`accordion-table-row-${data.type}-${data.id}`}
        data-id={data.id} className="accordion-table-row"
        data-type={type}>
        {this.renderArrow()}
        <div className="accordion-table-row__content">
          {renderContent(data)}
        </div>
      </div>
    );
  }

  renderDescendants() {
    const { data } = this.props;

    if (!this.state.isExpanded) {
      return null;
    }

    return (
      <RowDescendants
        key={`accordion-table-row-descendants-${data.type}-${data.id}`}
        ancestor={data}
        renderContent={this.props.renderDescendants} />
    );
  }

  render() {
    return (
      [
        this.renderRow(),
        this.renderDescendants()
      ]
    );
  }

}

export default Row;
