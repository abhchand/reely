import JsonApiDataStore from 'javascript/models/framework/data-store';

function initFromJsonApiData(jsonApiData) {
  /**
   * The datastore already does the work of
   * parsing JsonApi data and ininitializing models,
   * so don't duplicate logic.
   *
   * Just create a new instance of the data store for this
   * single purpose and extract the models it creates.
   */

  const dataStore = new JsonApiDataStore();
  return dataStore.sync(jsonApiData);
}

export { initFromJsonApiData };
