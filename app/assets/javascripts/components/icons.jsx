var IconArrowThickLeft = React.createClass({
  propTypes: {
    size: React.PropTypes.string,
    fillColor: React.PropTypes.string
  },

  getDefaultProps: function() {
    return {
      size: "32",
      fillColor: "#EEEEEE"
    };
  },

  render: function() {
    return (
      // icons/arrow-thick-left.svg
      <svg width={this.props.size} height={this.props.size} xmlns="http://www.w3.org/2000/svg"viewBox="0 0 8 8">
        <path d="M3 0l-3 3.03 3 2.97v-2h5v-2h-5v-2z" transform="translate(0 1)" fill={this.props.fillColor}></path>
      </svg>
    );
  }
});

var IconArrowThickRight = React.createClass({
    propTypes: {
    size: React.PropTypes.string,
    fillColor: React.PropTypes.string
  },

  getDefaultProps: function() {
    return {
      size: "32",
      fillColor: "#EEEEEE"
    };
  },

  render: function() {
    return (
      // icons/arrow-thick-right.svg
      <svg width={this.props.size} height={this.props.size} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 8 8">
        <path d="M5 0v2h-5v2h5v2l3-3.03-3-2.97z" transform="translate(0 1)" fill={this.props.fillColor}></path>
      </svg>
    );
  }
});

var IconX = React.createClass({
    propTypes: {
    size: React.PropTypes.string,
    fillColor: React.PropTypes.string
  },

  getDefaultProps: function() {
    return {
      size: "32",
      fillColor: "#EEEEEE"
    };
  },

  render: function() {
    return (
      // icons/arrow-thick-right.svg
      <svg width={this.props.size} height={this.props.size} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 8 8">
        <path d="M1.41 0l-1.41 1.41.72.72 1.78 1.81-1.78 1.78-.72.69 1.41 1.44.72-.72 1.81-1.81 1.78 1.81.69.72 1.44-1.44-.72-.69-1.81-1.78 1.81-1.81.72-.72-1.44-1.41-.69.72-1.78 1.78-1.81-1.78-.72-.72z" fill={this.props.fillColor}></path>
      </svg>
    );
  }
});
