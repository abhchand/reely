var Photo = React.createClass({
  propTypes:{
    photo: React.PropTypes.object.isRequired,
    photoIndex: React.PropTypes.number.isRequired,
    editModeEnabled: React.PropTypes.bool.isRequired,
    isSelected: React.PropTypes.bool.isRequired,
    handleClickWhenEditModeEnabled: React.PropTypes.func.isRequired,
    handleClickWhenEditModeDisabled: React.PropTypes.func.isRequired
  },

  photoUrl: function() {
    return this.props.photo.mediumUrl;
  },

  handleClick: function(e) {
    if (this.props.editModeEnabled) {
      this.props.handleClickWhenEditModeEnabled(this.props.photoIndex);
    } else {
      this.props.handleClickWhenEditModeDisabled(this.props.photoIndex);
    }
  },

  renderOverlay: function() {
    if (this.props.editModeEnabled) {
      return this.renderOverlayWhenEditModeEnabled();
    } else {
      return this.renderOverlayWhenEditModeDisabled();
    }
  },

  renderOverlayWhenEditModeEnabled: function() {
    if (this.props.isSelected) {
      return (
        <div className="photo-grid__photo-selected-overlay">
          <IconCheckMark fillColor="#FFFFFF" />
        </div>
      );
    }
  },

  renderOverlayWhenEditModeDisabled: function() {
    return (
      <div className="photo-grid__photo-overlay">
        <span className="photo-grid__taken-at-label">
          {this.props.photo.takenAtLabel}
        </span>
      </div>
    );
  },

  render: function() {
    var divStyle = { backgroundImage: 'url(' + this.photoUrl() + ')' };
    var selectedClass = this.props.isSelected ? " selected" : "";

    return (
      <div
        data-id={this.props.photo.id}
        className={"photo-grid__photo-container" + selectedClass}
        onClick={this.handleClick}>

        <div className="photo-grid__photo covered-background" style={divStyle}>
          {this.renderOverlay()}
        </div>
      </div>
    );
  }
});
