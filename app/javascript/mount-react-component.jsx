import React from 'react';
import ReactDOM from 'react-dom';

function mountReactComponent(Component, mountNodeId) {
  document.addEventListener('DOMContentLoaded', () => {
    const mountNode = document.getElementById(`react-mount-${mountNodeId}`);
    const propsJSON = mountNode.getAttribute('data-react-props');
    const props = JSON.parse(propsJSON);

    ReactDOM.render(<Component {...props} />, mountNode);
  });
}

export default mountReactComponent;
