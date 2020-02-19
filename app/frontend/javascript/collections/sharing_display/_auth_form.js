$(document).ready(() => {
  $('.auth-prompt').on('click', '.close', (e) => {
    const authPrompt = $(e.target).closest('.auth-prompt')[0];
    authPrompt.parentNode.removeChild(authPrompt);
  });
});
