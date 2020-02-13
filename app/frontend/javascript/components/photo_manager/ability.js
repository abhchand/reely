class Ability {

  constructor(permissions) {
    this.permissions = permissions;

    this.canAddToCollection = this.canAddToCollection.bind(this);
    this.canEdit = this.canEdit.bind(this);
    this.canRemoveFromCollection = this.canRemoveFromCollection.bind(this);
  }

  canAddToCollection() {
    let { allowAddingToCollection } = this.permissions;

    if (typeof allowAddingToCollection == 'undefined') {
      allowAddingToCollection = false;
    }

    return this.canEdit() && allowAddingToCollection;
  }

  canDeleteCollection() {
    let { allowDeletingCollection } = this.permissions;

    if (typeof allowDeletingCollection == 'undefined') {
      allowDeletingCollection = false;
    }

    return this.canEdit() && allowDeletingCollection;
  }

  canEdit() {
    let { isEditable } = this.permissions;

    if (typeof isEditable == 'undefined') {
      isEditable = false;
    }

    return isEditable;
  }

  canRemoveFromCollection() {
    let { allowRemovingFromCollection } = this.permissions;

    if (typeof allowRemovingFromCollection == 'undefined') {
      allowRemovingFromCollection = false;
    }

    return this.canEdit() && allowRemovingFromCollection;
  }

  canShareCollection() {
    let { allowSharingCollection } = this.permissions;

    if (typeof allowSharingCollection == 'undefined') {
      allowSharingCollection = false;
    }

    return this.canEdit() && allowSharingCollection;
  }

}

export default Ability;
