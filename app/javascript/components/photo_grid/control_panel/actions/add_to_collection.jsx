import { IconPlus } from "components/icons";
import PropTypes from "prop-types";
import React from "react";
import ReactSelectOrCreate from "react-select-or-create";

class AddToCollection extends React.Component {
  static propTypes = {
    collections: PropTypes.array.isRequired,
    selectedPhotoIds: PropTypes.array.isRequired,
    // eslint-disable-next-line react/no-unused-prop-types
    onAddToExistingCollection: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props);

    this.i18nPrefix = "components.photo_grid.control_panel.bulk_action_panel.add_to_collection";

    this.addToExistingCollection = this.addToExistingCollection.bind(this);
    this.addToNewCollection = this.addToNewCollection.bind(this);
    this.addNotification = this.addNotification.bind(this);
  }

  addToExistingCollection(collectionId) {
    const self = this;
    const id = `id${  Math.random().toString(16).slice(2)}`;
    const data = {
      collection_id: collectionId,
      collection: {
        photo_ids: this.props.selectedPhotoIds
      }
    };

    $.ajax({
      type: "PUT",
      url: `/collections/${collectionId}/add-photos`,
      dataType: "json",
      data: JSON.stringify(data),
      contentType: "application/json"
    })
      .fail(function() {
        const content = I18n.t(`${self.i18nPrefix}.existing.error`);
        const notification = { id: id, content: content, type: "error" };

        self.addNotification(notification);
        self.props.onAddToExistingCollection();
      })
      .done(function() {
        const count = self.props.selectedPhotoIds.length;
        const msg = I18n.t(`${self.i18nPrefix}.existing.success`, { count: count, href: "/collections" });
        // eslint-disable-next-line react/no-danger
        const content = <span dangerouslySetInnerHTML={{__html: msg}}></span>;
        const notification = { id: id, content: content, type: "success" };

        self.addNotification(notification);
        self.props.onAddToExistingCollection();
      })
    ;
  }

  addToNewCollection(collectionName, prevCollections) {
    const self = this;
    const id = `id${  Math.random().toString(16).slice(2)}`;
    const data = {
      collection: {
        name: collectionName
      }
    };
    let newCollections;

    $.ajax({
      type: "POST",
      // Until react-select-or-create allows returning promises we need
      // to run this synchronously
      async: false,
      url: "/collections",
      dataType: "json",
      data: JSON.stringify(data),
      contentType: "application/json"
    })
      .fail(function() {
        const content = I18n.t(`${self.i18nPrefix}.new.error`);
        const notification = { id: id, content: content, type: "error" };

        self.addNotification(notification);
      })
      .done(function(collection) {
        const collectionId = collection.id;
        const msg = I18n.t(`${self.i18nPrefix}.new.success`, { href: `/collections/${collectionId}`, name: collection.name });
        // eslint-disable-next-line react/no-danger
        const content = <span dangerouslySetInnerHTML={{__html: msg}}></span>;
        const notification = { id: id, content: content, type: "success" };

        self.addNotification(notification);
        self.addToExistingCollection(collectionId);

        newCollections = prevCollections.unshift({ id: collection.id, name: collection.name });
      })
    ;

    return newCollections;
  }

  addNotification(notification) {
    window.action_notifications.add(notification);
  }

  render() {
    if (this.props.selectedPhotoIds.length === 0) {
      return null;
    }

    const textForCloseMenuButton = I18n.t(`${this.i18nPrefix}.btn_label`);
    const textForOpenMenuButton = () => (<IconPlus size="24" title={I18n.t(`${this.i18nPrefix}.tooltip`)} />);
    const textForEmptyState = I18n.t(`${this.i18nPrefix}.empty_state`);
    const textForNoSearchResults = I18n.t(`${this.i18nPrefix}.no_results`);
    const textForSearchInputPlaceholder = I18n.t(`${this.i18nPrefix}.search_placeholder`);
    const textForCreateItem = (searchValue) => {
      const key = searchValue === '' ? 'blank' : 'present';
      return I18n.t(`${this.i18nPrefix}.create.${key}`, { name: searchValue });
    };

    return (
      <li className={"icon-tray__item icon-tray__item--add-to-collection"}>
        <ReactSelectOrCreate
          items={this.props.collections}
          onCreate={this.addToNewCollection}
          onSelect={this.addToExistingCollection}
          textForCloseMenuButton={textForCloseMenuButton}
          textForOpenMenuButton={textForOpenMenuButton}
          textForEmptyState={textForEmptyState}
          textForNoSearchResults={textForNoSearchResults}
          textForSearchInputPlaceholder={textForSearchInputPlaceholder}
          textForCreateItem={textForCreateItem} />
      </li>
    );
  }
}

export default AddToCollection;
