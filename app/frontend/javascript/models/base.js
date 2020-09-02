/*
 * A model representing an individual database record.
 *
 * This model doesn't not attempt to be 1:1 with or replicate all
 * the functionality of the server-side Ruby model.
 *
 * It is a convenience wrapper of helper methods, getters, and setters
 * built around the core JSON data object returned by the server.
 *
 * It's also a "dumb" class that uses minimal logic. For example, if
 * a model has a `fooId` attribute and a `foo` association, we don't
 * enforce that they agree with each other and point to the same
 * record id.
 *
 * All responses from the server are constructed in JSON API format. See
 * specification here: https://jsonapi.org
 *
 */

class Base {

  constructor(jsonApiResponse) {
    this._jsonApiResponse = jsonApiResponse;
    this._associations = {};

    // Function Bindings
    this.id = this.id.bind(this);
    this.type = this.type.bind(this);
    this.asJson = this.asJson.bind(this);
    this.eq = this.eq.bind(this);
    this.attr = this.attr.bind(this);
    this.setAttr = this.setAttr.bind(this);
    this.bulkSetAttrs = this.bulkSetAttrs.bind(this);
    this.association = this.association.bind(this);
    this.addAssociation = this.addAssociation.bind(this);
    this.removeAssociation = this.removeAssociation.bind(this);
    this.setAssociation = this.setAssociation.bind(this);
  }

  id() {
    return this._jsonApiResponse.id;
  }

  type() {
    return this._jsonApiResponse.type;
  }

  asJson() {
    return JSON.parse(JSON.stringify(this._jsonApiResponse));
  }

  // Test equality between any two models
  eq(model) {
    return model.id() === this.id() && model.type() === this.type();
  }

  // Simple getter to retrieve a JsonApi attribute
  attr(attrName) {
    let attrValue = this._jsonApiResponse.attributes[attrName];

    /**
     * The JsonApi specification that id's must be strings:
     *
     *   Every resource object MUST contain an id member and a type member.
     *   The values of the id and type members MUST be strings.
     *
     * See: https://jsonapi.org/format/
     *
     * The statement above is in reference to top level ID values,
     * so it's not clear whether references to other associations
     * (e.g. `fooId`) should also be strings. But if they are not it
     * leads to downstream issues trying to compare number and string
     * ids, so we blindly convert all attributes to string if they end
     * in `Id`.
     *
     * Note that this is case sensitive - we wouldn't want attributes that
     * happen to end in 'id' to also be impacted
     */
    if (attrValue && attrName.match(/Id$/)) { attrValue = attrValue.toString(); }

    return attrValue;
  }

  // Simple setter to set a JsonApi attribute
  setAttr(attrName, attrValue) {
    this._jsonApiResponse.attributes[attrName] = attrValue;
  }

  // Simple setter to bulk set a JsonApi attributet
  bulkSetAttrs(attrs) {
    Object.keys(attrs).forEach((key) => {
      this.setAttr(key, attrs[key]);
    });
  }

  /*
   * Simple getter to retrieve an associated record.
   * We don't distinguish between one and many associations,
   * we just always blindly return an array of associations.
   */
  association(assocName) {
    return this._associations[assocName] || [];
  }

  /*
   * Simple setter to add an associated record.
   * We don't distinguish between one and many associations,
   * we just blindly store all associations as an array of
   * records. We also don't validate order in any way, but
   * we do ensure uniqueness so that a given record will not
   * get double-added.
   */
  addAssociation(assocName, record) {
    if (!this._associations.hasOwnProperty(assocName)) {
      this._associations[assocName] = [];
    }

    // If this record already exists, do nothing
    const idx = this._associations[assocName].indexOf(record);
    if (idx > -1) { return; }

    this._associations[assocName].push(record);
  }

  /*
   * Simple setter to remove an record from an existing
   * association.
   */
  removeAssociation(assocName, record) {
    if (!this._associations.hasOwnProperty(assocName)) {
      return;
    }

    const idx = this._associations[assocName].indexOf(record);

    if (idx > -1) {
      this._associations[assocName].splice(idx, 1);
    }
  }

  /*
   * Simple setter to set a collection of records as an
   * association.
   *
   * NOTE: This replaces all records for a given association!
   * If you'd like to add a single association, use
   * `addAssociation()` instead.
   */
  setAssociation(assocName, newRecords) {
    this._associations[assocName] = newRecords;
  }

}

export default Base;
