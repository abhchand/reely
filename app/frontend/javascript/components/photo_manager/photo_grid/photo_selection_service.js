class PhotoSelectionService {
  constructor(photoData, selectedPhotoIds, clickedPhotoIndex, clickEvent) {
    this.photoData = photoData;
    this.selectedPhotoIds = selectedPhotoIds;

    this.clickedPhotoIndex = clickedPhotoIndex;
    this.clickedPhotoId = photoData[clickedPhotoIndex].id;

    this.clickEvent = clickEvent;
  }

  performSelection() {
    this.isBulkSelection()
      ? this.performBulkSelection()
      : this.toggleClickedPhoto();
  }

  isBulkSelection() {
    return (
      Boolean(this.clickEvent) &&
      this.clickEvent.shiftKey &&
      this.selectedPhotoIds.length > 0
    );
  }

  /*
   * Upon shift-clicking a photo, select multiple photos at once using the
   * following logic:
   *
   *  1. The first select photo is always used as an anchor point
   *  2. The shift-clicked photo is always used a a destination point
   *  3. All photos between the anchor and destination (inclusive) are selected
   *  4. All other pre-existing selections are cleared
   *
   * Since the final selection state is stored as a list of ids and not indexes,
   * it is important that list stays in order. So order matters and it is
   * assumed this service also receives the list in the proper display order.
   */
  performBulkSelection() {
    const firstSelectedPhotoId = this.selectedPhotoIds[0];
    let firstSelectedPhotoIndex;

    for (let n = 0; n < this.photoData.length; n++) {
      if (this.photoData[n].id === firstSelectedPhotoId) {
        firstSelectedPhotoIndex = n;
        break;
      }
    }

    const lower = Math.min(firstSelectedPhotoIndex, this.clickedPhotoIndex);
    const upper = Math.max(firstSelectedPhotoIndex, this.clickedPhotoIndex);

    const newSelectedPhotoIds = [];

    for (let i = lower; i <= upper; i++) {
      newSelectedPhotoIds.push(this.photoData[i].id);
    }

    this.selectedPhotoIds = newSelectedPhotoIds;
  }

  toggleClickedPhoto() {
    this.isClickedPhotoSelected()
      ? this.unselectClickedPhoto()
      : this.selectClickedPhoto();
  }

  isClickedPhotoSelected() {
    return this.selectedPhotoIds.indexOf(this.clickedPhotoId) >= 0;
  }

  unselectClickedPhoto() {
    // Unselect photo by removing it from array
    const index = this.selectedPhotoIds.indexOf(this.clickedPhotoId);
    if (index !== -1) {
      this.selectedPhotoIds.splice(index, 1);
    }
  }

  selectClickedPhoto() {
    // Select photo by adding it to array
    this.selectedPhotoIds.push(this.clickedPhotoId);
  }
}

export default PhotoSelectionService;
