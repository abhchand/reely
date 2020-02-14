import DeleteCollection from './actions/delete_collection';
import DownloadCollection from './actions/download_collection';
import OpenButton from './actions/open_button';
import React from 'react';
import ShareCollection from './actions/share_collection';

/* eslint-disable react/prop-types */

function hasCurrentCollection(props) {
  return Boolean(props.currentCollection);
}

function actionDeleteCollection(props) {
  if (!(props.ability.canDeleteCollection() && hasCurrentCollection(props))) {
    return null;
  }

  return <DeleteCollection collection={props.currentCollection} />;
}

function actionDownloadCollection(props) {
  if (!(props.ability.canDownloadCollection() && hasCurrentCollection(props))) {
    return null;
  }

  return <DownloadCollection collection={props.currentCollection} />;
}

function actionOpenPanel(props) {
  return <OpenButton onClick={props.openPanel} />;
}

function actionShareCollection(props) {
  if (!(props.ability.canShareCollection() && hasCurrentCollection(props))) {
    return null;
  }

  return <ShareCollection collection={props.currentCollection} />;
}

/* eslint-enable react/prop-types */

export {
  actionDeleteCollection,
  actionDownloadCollection,
  actionOpenPanel,
  actionShareCollection
};
