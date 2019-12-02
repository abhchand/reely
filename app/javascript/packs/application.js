/* eslint no-console:0 */

// Expose JQuery globally
window.$ = window.jQuery = require('jquery');
require('jquery-ujs');

import 'core-js/stable';

import 'mount-react-component';

import 'application/_mobile_navigation.js';
import 'application/_modal.js';
import 'application/flash.js';

import 'collections/_card.js';
import 'collections/_delete_modal.js';
import 'collections/_editable_name_heading.js';
import 'collections/_share_modal.jsx';
import 'collections/show.js';

import 'components/photo_manager';
import 'components/action_notifications';
