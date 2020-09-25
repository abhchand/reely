import Header from './header';
import PropTypes from 'prop-types';
import React from 'react';
import Row from './row';

class AccordionTable extends React.Component {
  static propTypes = {
    name: PropTypes.string.isRequired,
    data: PropTypes.array.isRequired,
    renderHeaderContent: PropTypes.func.isRequired,
    renderRowContent: PropTypes.func.isRequired,
    renderDescendants: PropTypes.func
  };

  render() {
    const props = this.props;

    return (
      <div className={`accordion-table accordion-table--${props.name}`}>
        <Header
          key={`accordion-table-${props.name}`}
          renderContent={props.renderHeaderContent}
        />

        {this.props.data.map((item) => {
          return (
            <Row
              key={`accordion-table-row-element-${item._type}-${item.id}`}
              data={item}
              type={props.name}
              renderContent={props.renderRowContent}
              renderDescendants={props.renderDescendants}
            />
          );
        })}
      </div>
    );
  }
}

export default AccordionTable;
