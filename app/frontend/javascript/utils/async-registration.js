function initializeAsyncRegistration() {
  if (
    typeof window.asyncRegistration === 'object' &&
    Array.isArray(window.asyncRegistration)
  ) {
    return;
  }

  window.asyncRegistration = [];
}

function registerAsyncProcess(name) {
  initializeAsyncRegistration();

  if (window.asyncRegistration.indexOf(name) > -1) {
    return;
  }

  window.asyncRegistration.push(name);
}

function unregisterAsyncProcess(name) {
  const index = window.asyncRegistration.indexOf(name);
  if (index > -1) {
    window.asyncRegistration.splice(index, 1);
  }
}

export { registerAsyncProcess, unregisterAsyncProcess };
