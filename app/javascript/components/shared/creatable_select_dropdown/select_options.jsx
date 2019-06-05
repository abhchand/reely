import {IconCollection} from "components/icons";
import {parseKeyCode} from "utils";
import PropTypes from "prop-types";
import React from "react";

class SelectOptions extends React.Component {
  static propTypes = {
    options: PropTypes.array.isRequired,
    // eslint-disable-next-line react/no-unused-prop-types
    currentSelectedOptionIndex: PropTypes.number.isRequired,

    onClick: PropTypes.func.isRequired,

    textForEmptyState: PropTypes.string
  };

  static defaultProps = {
    textForEmptyState: "No results"
  }

  constructor(props) {
    super(props);

    this.onClick = this.onClick.bind(this);
    this.onKeyDown = this.onKeyDown.bind(this);
    this.renderEmptyState = this.renderEmptyState.bind(this);
    this.renderOptions = this.renderOptions.bind(this);
  }

  onClick(e) {
    const optionId = e.currentTarget.dataset.id;
    this.props.onClick(optionId);
  }

  onKeyDown(e) {
    switch(parseKeyCode(e)) {
      case 13: {
        // Enter
        this.onClick(e);
        break;
      }
    }
  }

  renderEmptyState() {
    return <span className="empty-state">{this.props.textForEmptyState}</span>;
  }

  renderOptions() {
    const options = this.props.options;
    let counter = -1;
    const self = this;

    return (
      options.map(function(option) {
        counter += 1;
        const className = (counter === self.props.currentSelectedOptionIndex ? "selected" : "");

        // TODO: IconCollection should a generic and not collection-specific
        //
        // NOTE: WAI-ARIA recommends event listeners are not placed on
        // non-interactive elements such as <li>. Recommended alternative
        // is an internal <div> containing the event listeners and letting
        // <li> preseve its semantic meaning as a container.
        //
        // eslint-disable-next-line max-len
        // See: github.com/evcohen/eslint-plugin-jsx-a11y/blob/master/docs/rules/no-noninteractive-element-interactions.md
        return (
          <li key={option.id} data-id={option.id} className={className}>
            <div data-id={option.id} role="presentation" onClick={self.onClick} onKeyDown={self.onKeyDown}>
              <IconCollection size="20" fillColor="#4F14C8" />
              {option.html || <span>{option.name}</span>}
            </div>
          </li>
        );
      })
    );
  }

  render() {
    const content = this.props.options.length === 0 ? this.renderEmptyState() : this.renderOptions();

    return (
      <ul data-testid="select-options" className="creatable-select-dropdown-select-options">
        {content}
      </ul>
    );
  }
}

export default SelectOptions;
