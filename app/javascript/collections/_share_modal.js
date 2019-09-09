import React from "react";
import ReactDOM from "react-dom";
import ShareCollection from "../components/share_collection/share_collection";

// Open
function openCollectionsShareModal(dataId, dataName) {
  const collection = { id: dataId, name: dataName };

  ReactDOM.render(
    <ShareCollection collection={collection} />,
    document.getElementById("collections-share-modal-content")
  );

  // Open modal
  $(".collections-share-modal").addClass("active");
}

// Close
$(document).ready(function() {
  $(".collections-share-modal").on("click", ".modal-content__button--close", function() {

    // Close modal
    $(".collections-share-modal").removeClass("active");
  });
});

export {openCollectionsShareModal};
