import {IconArrowThickLeft, IconArrowThickRight, IconX} from "icons";
import PropTypes from "prop-types";
import React from "react";

class PhotoCarousel extends React.Component {
  static propTypes = {
    photoData: PropTypes.array.isRequired,
    clickedPhotoIndex: PropTypes.number.isRequired,
    closeCarousel: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props);

    this.componentDidMount = this.componentDidMount.bind(this);
    this.componentWillUnmount = this.componentWillUnmount.bind(this);
    this.handleKeyDown = this.handleKeyDown.bind(this);
    this.currentPhoto = this.currentPhoto.bind(this);
    this.navigateNext = this.navigateNext.bind(this);
    this.navigatePrev = this.navigatePrev.bind(this);

    this.state = {
      currentPhotoIndex: this.props.clickedPhotoIndex
    };
  }

  componentDidMount() {
    $(document.body).on("keydown", this.handleKeyDown);
  }

  componentWillUnmount() {
    $(document.body).off("keydown", this.handleKeyDown);
  }

  handleKeyDown(e) {
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
  }

  currentPhoto() {
    return this.props.photoData[this.state.currentPhotoIndex];
  }

  navigateNext() {
    let newIndex = this.state.currentPhotoIndex + 1;
    if (newIndex >= this.props.photoData.length) {
      newIndex = 0;
    }

    this.setState({currentPhotoIndex: newIndex});
  }

  navigatePrev() {
    let newIndex = this.state.currentPhotoIndex - 1;
    if (newIndex < 0) {
      newIndex = this.props.photoData.length - 1;
    }

    this.setState({currentPhotoIndex: newIndex});
  }

  render() {
    const divStyle = { backgroundImage: `url(${  this.currentPhoto().url  })` };

    return (
      <div className="photo-carousel">
        <div className="photo-carousel__content" data-id={this.currentPhoto().id} style={divStyle}>

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
}

export default PhotoCarousel;
