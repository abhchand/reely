var PhotoCarousel = React.createClass({
  propTypes:{
    photoData: React.PropTypes.array.isRequired,
    currentPhotoIndex: React.PropTypes.number.isRequired,
    navigatePrev: React.PropTypes.func.isRequired,
    navigateNext: React.PropTypes.func.isRequired,
    closeCarousel: React.PropTypes.func.isRequired
  },

  componentDidMount: function() {
    $(document.body).on("keydown", this.handleKeyDown);
  },

  componentWillUnmount: function() {
    $(document.body).off("keydown", this.handleKeyDown);
  },

  // TODO: Get this working
  handleKeyDown: function(e) {
    switch(e.keyCode) {
      case 27:
        // Escape
        this.props.closeCarousel();
        break;
      case 37:
        // Left Arrow
        this.props.navigatePrev();
        break;
      case 39:
        // Right Arrow
        this.props.navigateNext();
        break;
      case 75:
        // Letter 'k'
        this.props.navigatePrev();
        break;
      case 74:
        // Letter 'j'
        this.props.navigateNext();
        break;
    }
  },

  render: function() {
    var photoUrl = this.props.photoData[this.props.currentPhotoIndex].url;
    var photoId = this.props.photoData[this.props.currentPhotoIndex].id;
    var divStyle = { backgroundImage: 'url(' + photoUrl + ')' };

    return (
      <div className="photo-carousel">
        <div className="photo-carousel__content" data-id={photoId} style={divStyle}>

          <div className="photo-carousel__close" onClick={this.props.closeCarousel}>
            <IconX size="16"/>
          </div>

          <div className="photo-carousel__navigation-container prev" onClick={this.props.navigatePrev}>
            <div className="photo-carousel__navigation">
              <IconArrowThickLeft size="24" />
            </div>
          </div>

          <div className="photo-carousel__navigation-container next" onClick={this.props.navigateNext}>
            <div className="photo-carousel__navigation">
              <IconArrowThickRight size="24" />
            </div>
          </div>
        </div>
      </div>
    );
  }
});
