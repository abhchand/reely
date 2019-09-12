import {openCollectionsDeleteModal} from "common.js";
import {openCollectionsShareModal} from "./_share_modal";

// Delete
$(document).ready(function() {
  $(".collections-show__action-bar").on("click", ".collections-show__action-bar-item--delete", function() {
    const dataId = $(".collections-show__action-bar").attr("data-id");
    const dataName = $("#collection_name").val();

    openCollectionsDeleteModal(dataId, dataName);
  });
});

// Share
$(document).ready(function() {
  $(".collections-show__action-bar").on("click", ".collections-show__action-bar-item--share", function() {
    const dataId = $(".collections-show__action-bar").attr("data-id");
    const dataName = $("#collection_name").val();

    openCollectionsShareModal(dataId, dataName);
  });
});
