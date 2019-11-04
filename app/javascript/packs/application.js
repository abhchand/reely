/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual
// application logic in a relevant structure within app/javascript and only
// use these pack files to reference that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %>
// to the appropriate layout file, like app/views/layouts/application.html.erb

// Expose JQuery globally
window.$ = window.jQuery = require("jquery");
require("jquery-ujs");

import "core-js/stable";

import "mount-react-component";

import "application/_mobile_navigation.js";
import "application/_modal.js";
import "application/flash.js";

import "collections/_card.js";
import "collections/_delete_modal.js";
import "collections/_editable_name_heading.js";
import "collections/_share_modal.jsx";
import "collections/show.js";

import "components/photo_grid";
import "components/action_notifications";
