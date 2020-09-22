/**
 * @class BaseModel
 *
 * Original implementation taken from:
 * https://github.com/beauby/jsonapi-datastore/blob/master/src/jsonapi-datastore.js
 * (Original class name: `JsonApiDataStoreModel`)
 */
class BaseModel {


  /**
   * @method constructor
   * @param {string} type The type of the model.
   * @param {string} id The id of the model.
   */
  constructor(type, id) {
    this.id = id;
    this._type = type;
    this._attributes = [];
    this._relationships = [];
  }

  eq(model) {
    return model.id === this.id && model._type === this._type;
  }

  /**
   * Serialize a model.
   * @method serialize
   * @param {object} opts The options for serialization.  Available properties:
   *
   *  - `{array=}` `attributes` The list of attributes to be serialized (default: all attributes).
   *  - `{array=}` `relationships` The list of relationships to be serialized (default: all relationships).
   * @return {object} JSONAPI-compliant object
   */
  serialize(opts) {
    let self = this,
      res = { data: { type: this._type } },
      key;

    opts = opts || {};
    opts.attributes = opts.attributes || this._attributes;
    opts.relationships = opts.relationships || this._relationships;

    if (this.id !== undefined) { res.data.id = this.id; }
    if (opts.attributes.length !== 0) { res.data.attributes = {}; }
    if (opts.relationships.length !== 0) { res.data.relationships = {}; }

    opts.attributes.forEach((key) => {
      res.data.attributes[key] = self[key];
    });

    opts.relationships.forEach((key) => {
      function relationshipIdentifier(model) {
        return { type: model._type, id: model.id };
      }
      if (!self[key]) {
        res.data.relationships[key] = { data: null };
      }
      else if (self[key].constructor === Array) {
        res.data.relationships[key] = {
          data: self[key].map(relationshipIdentifier)
        };
      }
      else {
        res.data.relationships[key] = {
          data: relationshipIdentifier(self[key])
        };
      }
    });

    return res;
  }

  /**
   * Set/add an attribute to a model.
   * @method setAttribute
   * @param {string} attrName The name of the attribute.
   * @param {object} value The value of the attribute.
   */
  setAttribute(attrName, value) {
    if (this._attributes.indexOf(attrName) === -1) { this._attributes.push(attrName); }
    this[attrName] = value;
  }

  /**
   * Set a relationships to a model.
   * @method setRelationship
   * @param {string} relName The name of the relationship.
   * @param {object} modelOrCollection The linked model(s).
   */
  setRelationship(relName, modelOrCollection) {
    if (this._relationships.indexOf(relName) === -1) { this._relationships.push(relName); }
    this[relName] = modelOrCollection;
  }

  /**
   * Add a relationships to a model.
   * @method addToRelationship
   * @param {string} relName The name of the relationship.
   * @param {object} model The linked models.
   */
  addToRelationship(relName, model) {
    const curModels = this[relName] || [];

    // Only operate on collections, not single relationships
    if (!Array.isArray(curModels)) { return; }

    const idx = curModels.indexOf(model);
    if (idx > -1) { return; }

    this.setRelationship(relName, curModels.concat([model]));
  }

  /**
   * Remove relationships from a model.
   * @method removeFromRelationship
   * @param {string} relName The name of the relationship.
   * @param {object} model The linked models.
   */
  removeFromRelationship(relName, model) {
    const curModels = this[relName] || [];

    // Only operate on collections, not single relationships
    if (!Array.isArray(curModels)) { return; }

    const idx = curModels.indexOf(model);
    if (idx === -1) { return; }

    curModels.splice(idx, 1);
    this.setRelationship(relName, curModels);
  }

}

export default BaseModel;
