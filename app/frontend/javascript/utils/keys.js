import { os } from './os';

const keyCodes = Object.freeze({
  ARROW_DOWN:  40,
  ARROW_LEFT:  37,
  ARROW_RIGHT: 39,
  ARROW_UP:    38,
  ENTER:       13,
  ESCAPE:      27,
  LETTER_B:    66,
  LETTER_J:    74,
  LETTER_K:    75
});

/*
 * Returns the symbol or label for the meta key on this operating
 * system. E.g. on OS X it returns '⌘'
 */
function metaKeyLabel() {
  return I18n.t(`utils.keys.meta_key.${os()}`);
}

function parseKeyCode(event) {
  // See: https://stackoverflow.com/q/4285627/2490003
  return typeof event.which == 'number' ? event.which : event.keyCode;
}

export {
  keyCodes,
  metaKeyLabel,
  parseKeyCode
};
