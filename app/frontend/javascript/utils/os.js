function os() {
  // See: https://stackoverflow.com/a/9514476/2490003
  const osName = window.navigator.oscpu;

  if (osName.match(/windows/iu)) {
    return 'windows';
  } else if (osName.match(/os x/iu)) {
    return 'osx';
  }
  return 'other';
}

export { os };
