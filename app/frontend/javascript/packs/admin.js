/* eslint no-console:0 */

// Expose JQuery globally
window.$ = window.jQuery = require('jquery');
require('jquery-ujs');

import 'core-js/stable';

import 'javascript/mount-react-component';

import 'javascript/application/_desktop_navigation';
import 'javascript/application/_mobile_navigation';
import 'javascript/application/_global_modal_close';
import 'javascript/application/flash.js';

import 'javascript/admin/users/admin_user_manager';
