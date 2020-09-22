import JsonApiDataStore from './framework/data-store';

/**
 * Export a single instance of the dataStore to be
 * shared and used app-wide. Changes made to the
 * data store in one component will automatically
 * update the instance and be available to other
 * components.
 *
 * If an individual component really has the need
 * for another datastore instance it can import
 * it directly as needed.
 */
const dataStore = new JsonApiDataStore();
export default dataStore;
