import CreatableSelectDropdown from "components/shared/creatable_select_dropdown/creatable_select_dropdown";
import PropTypes from "prop-types";
import React from "react";

class BulkActionAddToCollection extends React.Component {
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

  addToNewCollection(collectionName) {
    const self = this;
    const id = `id${  Math.random().toString(16).slice(2)}`;
    const data = {
      collection: {
        name: collectionName
      }
    };

    $.ajax({
      type: "POST",
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
      })
    ;
  }

  addNotification(notification) {
    window.action_notifications.add(notification);
  }

  render() {
    const textForCloseMenuButton = I18n.t(`${this.i18nPrefix}.close_menu`);
    const textForOptionsEmptyState = I18n.t(`${this.i18nPrefix}.empty_state`);
    const textForSearchInputPlaceholder = I18n.t(`${this.i18nPrefix}.search_placeholder`);
    const textGeneratorForCreateOption = (collection) => (I18n.t(`${this.i18nPrefix}.create`, { name: collection }));

    return (
      <div
        role="presentation"
        className={"photo-grid-bulk-action-panel__item photo-grid-bulk-action-panel__item--add-to-collection"}>
        {
          <CreatableSelectDropdown
          options={this.props.collections}
          onCreate={this.addToNewCollection}
          onSelect={this.addToExistingCollection}
          textForCloseMenuButton={textForCloseMenuButton}
          textForOptionsEmptyState={textForOptionsEmptyState}
          textForSearchInputPlaceholder={textForSearchInputPlaceholder}
          textGeneratorForCreateOption={textGeneratorForCreateOption} />
        }
      </div>
    );
  }
}

export default BulkActionAddToCollection;
