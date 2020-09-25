import { keyCodes, parseKeyCode } from 'javascript/utils/keys';

/*
 * Listen for "Meta Key (e.g. Windows/Command/Super) + b" is pressed and
 * focus on the search bar
 */
document.addEventListener('keydown', (event) => {
  if (event.metaKey && parseKeyCode(event) === keyCodes.LETTER_B) {
    event.preventDefault();

    const element = document.getElementsByClassName(
      'filter-table__search-input'
    )[0];
    if (element) element.focus();
  }
});
