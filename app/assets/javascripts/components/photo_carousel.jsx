var PhotoCarousel = React.createClass({
  propTypes:{
    photoData: React.PropTypes.array.isRequired,
    clickedPhotoIndex: React.PropTypes.number.isRequired,
    closeCarousel: React.PropTypes.func.isRequired
  },

  getInitialState: function() {
    return {
      currentPhotoIndex: this.props.clickedPhotoIndex
    }
  },

  componentDidMount: function() {
    $(document.body).on("keydown", this.handleKeyDown);
  },

  componentWillUnmount: function() {
    $(document.body).off("keydown", this.handleKeyDown);
  },

  handleKeyDown: function(e) {
    switch(e.keyCode) {
      case 27:
        // Escape
        this.props.closeCarousel();
        break;
      case 37:
        // Left Arrow
        this.navigatePrev();
        break;
      case 39:
        // Right Arrow
        this.navigateNext();
        break;
      case 75:
        // Letter 'k'
        this.navigatePrev();
        break;
      case 74:
        // Letter 'j'
        this.navigateNext();
        break;
    }
  },

  currentPhoto: function() {
    return this.props.photoData[this.state.currentPhotoIndex];
  },

  navigateNext: function() {
    newIndex = this.state.currentPhotoIndex + 1;
    if (newIndex >= this.props.photoData.length) {
      newIndex = 0;
    }

    this.setState({currentPhotoIndex: newIndex});
  },

  navigatePrev: function() {
    newIndex = this.state.currentPhotoIndex - 1;
    if (newIndex < 0) {
      newIndex = this.props.photoData.length - 1;
    }

    this.setState({currentPhotoIndex: newIndex});
  },

  render: function() {
    var divStyle = { backgroundImage: 'url(' + this.currentPhoto().url + ')' };

    return (
      <div className="photo-carousel">
        <div className="photo-carousel__content" data-id={this.currentPhoto.id} style={divStyle}>

          <div className="photo-carousel__close" onClick={this.props.closeCarousel}>
            <IconX size="16"/>
          </div>

          <div className="photo-carousel__navigation-container prev" onClick={this.navigatePrev}>
            <div className="photo-carousel__navigation">
              <IconArrowThickLeft size="24" />
            </div>
          </div>

          <div className="photo-carousel__navigation-container next" onClick={this.navigateNext}>
            <div className="photo-carousel__navigation">
              <IconArrowThickRight size="24" />
            </div>
          </div>
        </div>
      </div>
    );
  }
});
