function dateToYMD(date) {
  const d = date.getDate();
  const m = date.getMonth() + 1;
  const y = date.getFullYear();

  // eslint-disable-next-line no-magic-numbers
  return `${String(y)}-${m <= 9 ? `0${m}` : m}-${d <= 9 ? `0${d}` : d}`;
}

export { dateToYMD };
