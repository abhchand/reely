const waitUntil = (condition) => {
  return new Promise((resolve, _reject) => {
    // eslint-disable-next-line
    (function waitForCondition(condition) {
      if (condition()) { return resolve(); }
      setTimeout(waitForCondition, 100, condition);
    }(condition));
  });
};

export {
  waitUntil
};
