import User from '../user';
import UserInvitation from '../user-invitation';

/**
 * @class JsonApiDataStore
 *
 * Original implementation taken from:
 * https://github.com/beauby/jsonapi-datastore/blob/master/src/jsonapi-datastore.js
 */
class JsonApiDataStore {
  static MODEL_TYPES = {
    userInvitation: UserInvitation,
    user: User
  };

  /**
   * @method constructor
   */
  constructor() {
    this.graph = {};

    this.destroy = this.destroy.bind(this);
    this.find = this.find.bind(this);
    this.findAll = this.findAll.bind(this);
    this.reset = this.reset.bind(this);
    this.syncWithMeta = this.syncWithMeta.bind(this);
    this.sync = this.sync.bind(this);

    this._findOrInit = this._findOrInit.bind(this);
    this._findOrInitPlaceholder = this._findOrInitPlaceholder.bind(this);
    this._syncRecord = this._syncRecord.bind(this);
    this._syncRecordAttributes = this._syncRecordAttributes.bind(this);
    this._syncRecordRelationships = this._syncRecordRelationships.bind(this);
  }

  /**
   * Remove a model from the store.
   * @method destroy
   * @param {object} model The model to destroy.
   */
  destroy(model) {
    delete this.graph[model._type][model.id];
  }

  /**
   * Retrieve a model by type and id. Constant-time lookup.
   * @method find
   * @param {string} type The type of the model.
   * @param {string} id The id of the model.
   * @return {object} The corresponding model if present, and null otherwise.
   */
  find(type, id) {
    if (!this.graph[type] || !this.graph[type][id]) {
      return null;
    }
    return this.graph[type][id];
  }

  /**
   * Retrieve all models by type.
   * @method findAll
   * @param {string} type The type of the model.
   * @return {object} Array of the corresponding model if present, and empty array otherwise.
   */
  findAll(type) {
    const self = this;

    if (!this.graph[type]) {
      return [];
    }
    return Object.keys(self.graph[type]).map((v) => {
      return self.graph[type][v];
    });
  }

  /**
   * Empty the store.
   * @method reset
   */
  reset() {
    this.graph = {};
  }

  /**
   * Sync a JSONAPI-compliant payload with the store and return any metadata included in the payload
   * @method syncWithMeta
   * @param {object} data The JSONAPI payload
   * @return {object} The model/array of models corresponding to the payload's primary resource(s) and any metadata.
   */
  syncWithMeta(payload) {
    const primary = payload.data,
      syncRecord = this._syncRecord;
    if (!primary) {
      return [];
    }
    if (payload.included) {
      payload.included.map(syncRecord);
    }
    return {
      data:
        primary.constructor === Array
          ? primary.map(syncRecord)
          : syncRecord(primary),
      meta: 'meta' in payload ? payload.meta : null
    };
  }

  /**
   * Sync a JSONAPI-compliant payload with the store.
   * @method sync
   * @param {object} data The JSONAPI payload
   * @return {object} The model/array of models corresponding to the payload's primary resource(s).
   */
  sync(payload) {
    return this.syncWithMeta(payload).data;
  }

  /**
   * PRIVATE
   */

  _findOrInit(type, id) {
    const klass = this.constructor.MODEL_TYPES[type];

    if (!klass) {
      throw `Unknown model type '${type}'`;
    }

    this.graph[type] = this.graph[type] || {};
    this.graph[type][id] = this.graph[type][id] || new klass(id);

    return this.graph[type][id];
  }

  _findOrInitPlaceholder(jsonRecord) {
    // Initialize a placeholder if no matching record exists
    if (!this.find(jsonRecord.type, jsonRecord.id)) {
      const placeHolderModel = this._findOrInit(jsonRecord.type, jsonRecord.id);
      placeHolderModel._placeHolder = true;
    }

    return this.graph[jsonRecord.type][jsonRecord.id];
  }

  _syncRecord(jsonRecord) {
    const model = this._findOrInit(jsonRecord.type, jsonRecord.id);

    /*
     * If this was a placeholder, we previously created this because
     * we didn't have enough information to create a full record and
     * we needed something to link to. Now that we're about to update
     * this record we can remove the placeholder status if it exists
     */
    delete model._placeHolder;

    this._syncRecordAttributes(model, jsonRecord);
    this._syncRecordRelationships(model, jsonRecord);

    return model;
  }

  _syncRecordAttributes(model, jsonRecord) {
    let attrName;

    for (attrName in jsonRecord.attributes) {
      model.setAttribute(attrName, jsonRecord.attributes[attrName]);
    }
  }

  _syncRecordRelationships(model, jsonRecord) {
    let relName;

    if (!jsonRecord.relationships) {
      return;
    }

    for (relName in jsonRecord.relationships) {
      const rel = jsonRecord.relationships[relName];

      if (rel.data === undefined || rel.data === null) {
        continue;
      }

      if (Array.isArray(rel.data)) {
        model.setRelationship(
          relName,
          rel.data.map(this._findOrInitPlaceholder)
        );
      } else {
        model.setRelationship(relName, this._findOrInitPlaceholder(rel.data));
      }
    }
  }
}

export default JsonApiDataStore;
