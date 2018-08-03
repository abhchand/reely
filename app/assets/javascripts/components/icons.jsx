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
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 32 32" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <title>Close Icon</title>
        <defs></defs>
        <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" stroke-linecap="square">
          <g id="Artboard-2" stroke={this.props.fillColor} stroke-width="2">
            <g id="Group" transform="translate(3.000000, 2.000000)">
                <path d="M0.5,26.5 L25.5,0.5" id="Line"></path>
                <path d="M0.5,26.5 L25.5,0.5" id="Line" transform="translate(13.000000, 13.500000) scale(1, -1) translate(-13.000000, -13.500000) "></path>
            </g>
          </g>
        </g>
      </svg>
    );
  }
});
