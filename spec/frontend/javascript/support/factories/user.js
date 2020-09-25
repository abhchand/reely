import { initFromJsonApiData } from 'javascript/support/utils/json-api';

let id = 1;

/**
 * @class Creates a new `User` object for testing
 */
class UserFactory {
  static defaultAttributes = {
    firstName: 'Devi',
    lastName: 'Vishwakumar',
    avatarPaths: {
      thumb: '/foo/bar-thumb.jpg',
      medium: '/foo/bar-medium.jpg'
    }
  };
}

/**
 * Creates a new `User` instance based of specified attributes.
 */
UserFactory.create = (attributes = {}, relationships = {}) => {
  // NOTE: These are shallow merges!
  const finalAttributes = { ...UserFactory.defaultAttributes, ...attributes };
  const finalRelationships = { ...relationships };

  const json = {
    data: {
      id: id.toString(),
      type: 'user',
      attributes: finalAttributes,
      relationships: finalRelationships
    }
  };

  // Increment our id for the next factory generated
  id += 1;

  return initFromJsonApiData(json);
};

export default UserFactory;
