function parseKeyCode(event) {
  // See: https://stackoverflow.com/q/4285627/2490003
  return (typeof event.which == "number") ? event.which : event.keyCode;
}

export {parseKeyCode};
