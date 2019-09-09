import PropTypes from "prop-types";
import React from "react";

class ShareCollection extends React.Component {
  static propTypes = {
    collection: PropTypes.object.isRequired
  }

  constructor(props) {
    super(props);

    this.state = {
    };
  }

  render() {
    return(
      <div>{this.props.collection.name}</div>
    );
  }
}

export default ShareCollection;
