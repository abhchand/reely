var PhotoGridEditToggle = React.createClass({
  propTypes:{
    editModeEnabled: React.PropTypes.bool.isRequired,
    toggleEditMode: React.PropTypes.func.isRequired
  },

  getInitialState: function() {
    return {
      currentPhotoIndex: this.props.clickedPhotoIndex
    }
  },

  render: function() {
    var fillColor = (this.props.editModeEnabled ? "#FFFFFF" : "#888888");

    return (
      <div
        className="photo-grid__edit-toggle"
        onClick={this.props.toggleEditMode}>
        <IconCheckMark size="22" fillColor={fillColor} />
      </div>
    );
  }
});
