/* eslint no-console:0 */

// Expose JQuery globally
window.$ = window.jQuery = require('jquery');
require('jquery-ujs');

import 'core-js/stable';

import 'javascript/application/_desktop_navigation';
import 'javascript/application/_global_modal_close';
import 'javascript/application/_mobile_navigation';
import 'javascript/application/flash.js';

import 'javascript/components/action_notifications';
import 'javascript/components/file_uploader';
import 'javascript/components/icons';
import 'javascript/components/modal';
import 'javascript/components/photo_manager';

import 'javascript/components/product_feedback_form';

import 'javascript/mount-react-component';
