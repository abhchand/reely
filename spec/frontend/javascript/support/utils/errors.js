function buildJsonApiError(errorOptions) {
  return {
    response: {
      data: {
        errors: [
          {
            title: errorOptions.title || null,
            description: errorOptions.description || null
          }
        ]
      }
    }
  };
}

export { buildJsonApiError };

