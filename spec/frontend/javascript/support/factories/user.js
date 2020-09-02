import User from 'javascript/models/user';

let id = 1;

/**
 * @class Creates a new `User` object for testing
 */
class UserFactory {
}

/**
 * @function
 * @static
 *
 * Creates a new `User` instance based of specified attributes.
 *
 * @param {object} [attributes] Any custom attributes to be set
 * @param {function} [callback] A callback to be invoked before
 *        creating the `User` object. Will receive the object
 *        that will be passed to `new User()` as the only arg.
 */
UserFactory.create = (attributes = null, callback = null) => {
  const defaultAttributes = {
    firstName: 'Devi',
    lastName: 'Vishwakumar',
    avatarPaths: {
      thumb: '/foo/bar-thumb.jpg',
      medium: '/foo/bar-medium.jpg'
    }
  };

  // NOTE: This is a shallow merge!
  const finalAttributes = { ...defaultAttributes, ...attributes };

  let json = {
    id: id.toString(),
    type: 'user',
    attributes: finalAttributes
  };

  if (callback) { json = callback(json); }

  // Increment our id for the next factory generated
  id += 1;

  return new User(json);
};

export default UserFactory;
