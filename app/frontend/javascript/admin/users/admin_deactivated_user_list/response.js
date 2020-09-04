import { extractUsersFromResponse } from 'javascript/users/index/user_list/response';

/**
 * We use the exact same logic here to extract and build `User` model objects
 * that the <UserList /> component also uses. Keep things in one place
 * and just import the logic directly from that component.
 */

export {
  extractUsersFromResponse
};
