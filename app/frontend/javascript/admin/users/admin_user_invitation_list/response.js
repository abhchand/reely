import UserInvitation from 'models/user-invitation';

/**
 * A handler responsible for transforming the data
 * returned by the HTTP response into a set of
 * UserInvitations that will be used to render the table.
 *
 * @param  {object} responseData A the response data from an HTTP
 *         response, in JsonApi structure.
 * @param  {object} responseData.data A list of user invitations
 * @param  {object} [responseData.included] A list of included associations
 *
 */
const extractUserInvitationsFromResponse = (responseData) => {
  return responseData.data.map((userInvitation) => new UserInvitation(userInvitation));
};

export {
  extractUserInvitationsFromResponse
};
