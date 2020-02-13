import AddToCollection from './actions/add_to_collection';
import CloseButton from './actions/close_button';
import React from 'react';
import RemoveFromCollection from './actions/remove_from_collection';

/* eslint-disable react/prop-types */

function hasSelectedAtLeastOnePhoto(props) {
  return props.selectedPhotoIds.length > 0;
}

function actionAddToCollection(props) {
  if (!(props.ability.canAddToCollection() && hasSelectedAtLeastOnePhoto(props))) {
    return null;
  }

  return (
    <AddToCollection
      collections={props.collections}
      updateCollections={props.updateCollections}
      selectedPhotoIds={props.selectedPhotoIds}
      onComplete={props.afterAdditionToCollection} />
  );
}

function actionClosePanel(props) {
  return <CloseButton onClick={props.closePanel} />;
}

function actionRemoveFromCollection(props) {
  if (!(props.ability.canRemoveFromCollection() &&
    hasSelectedAtLeastOnePhoto(props) &&
    Boolean(props.currentCollection))) {
    return null;
  }

  return (
    <RemoveFromCollection
      photoIdsToRemove={props.selectedPhotoIds}
      currentCollection={props.currentCollection}
      onComplete={props.afterRemovalFromCollection} />
  );
}

/* eslint-enable react/prop-types */

export {
  actionAddToCollection,
  actionClosePanel,
  actionRemoveFromCollection
};
