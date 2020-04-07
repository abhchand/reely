function parseJsonApiError(error) {
  const errorObj = error.response.data.errors[0] || {};
  return errorObj.description || errorObj.title || I18n.t('generic_error');
}

export { parseJsonApiError };
