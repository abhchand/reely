import ReactDOM from 'react-dom';

function openModal(component) {
  ReactDOM.render(
    component,
    document.getElementById('modal')
  );
}

export { openModal };
