function stripHtmlTags(str) {
  // Adapted from: https://stackoverflow.com/a/5002161/2490003
  // Potentially unsafe for some strings
  return str.replace(/<\/?[^>]+(>|$)/g, "");
}

export { stripHtmlTags };
