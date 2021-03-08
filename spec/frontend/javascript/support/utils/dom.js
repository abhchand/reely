const safelyFind = (wrapper, css) => {
  return wrapper.exists(css) ? wrapper.find(css) : null;
};

export { safelyFind };
