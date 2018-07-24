var PhotoGrid = React.createClass({
  propTypes:{
    photoData: React.PropTypes.array.isRequired
  },

  getInitialState: function() {
    return {
      showCarousel: false,
      currentPhotoIndex: null
    }
  },

  enableCarousel: function(e) {
    var photoGridEl = e.currentTarget;

    if (!!photoGridEl) {
      // Find index of the photo that was clicked
      var currentPhotoIndex = null;
      for (var i = 0; i < this.props.photoData.length; i++) {
        if (String(this.props.photoData[i].id) == $(photoGridEl).attr("data-id")) {
          currentPhotoIndex = i;
        }
      }

      if (currentPhotoIndex !== null) {
        this.setState({
          showCarousel: true,
          currentPhotoIndex: currentPhotoIndex
        });
      }
    }
  },

  disableCarousel: function(e) {
    this.setState({
      showCarousel: false,
      currentPhotoIndex: null
    });
  },

  nextCarouselPhoto: function() {
    newIndex = this.state.currentPhotoIndex + 1;
    if (newIndex >= this.props.photoData.length) {
      newIndex = 0;
    }

    this.setState({currentPhotoIndex: newIndex});
  },

  prevCarouselPhoto: function() {
    newIndex = this.state.currentPhotoIndex - 1;
    if (newIndex < 0) {
      newIndex = this.props.photoData.length - 1;
    }

    this.setState({currentPhotoIndex: newIndex});
  },

  renderCarousel: function() {
    if (this.state.showCarousel) {
      return (
        <PhotoCarousel
          photoData={this.props.photoData}
          currentPhotoIndex={this.state.currentPhotoIndex}
          navigatePrev={this.prevCarouselPhoto}
          navigateNext={this.nextCarouselPhoto}
          closeCarousel={this.disableCarousel}/>
      );
    } else {
     return null;
    }
  },

  render: function() {
    var self = this;

    return (
      <div className="photo-grid">
        {
          this.props.photoData.map(function(photo){
            var divStyle = { backgroundImage: 'url(' + photo.mediumUrl + ')' };

            return (
              <div
                key={`photo_${photo.id}`}
                data-id={photo.id}
                className="photo-grid__aspect-ratio"
                onClick={self.enableCarousel}>

                <div
                  className="photo-grid__grid-element covered-background"
                  style={divStyle}>
                  <div className="photo-grid__overlay">
                    <span className="photo-grid__taken-at-label">
                      {photo.takenAtLabel}
                    </span>
                  </div>
                </div>
              </div>
            );
          })
        }

        {this.renderCarousel()}
      </div>
    );
  }
});
