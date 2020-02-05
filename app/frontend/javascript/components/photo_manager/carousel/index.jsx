import { keyCodes, parseKeyCode } from 'utils/keys';
import { IconArrowThickLeft, IconArrowThickRight, IconX } from 'components/icons';
import PropTypes from 'prop-types';
import React from 'react';

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
    this.applyRotation = this.applyRotation.bind(this);
    this.setPhotoUrl = this.setPhotoUrl.bind(this);
    this.navigateNext = this.navigateNext.bind(this);
    this.navigatePrev = this.navigatePrev.bind(this);

    this.state = {
      currentPhotoIndex: this.props.clickedPhotoIndex
    };
  }

  componentDidMount() {
    $(document.body).on('keydown', this.handleKeyDown);
  }

  componentWillUnmount() {
    $(document.body).off('keydown', this.handleKeyDown);
  }

  handleKeyDown(e) {
    switch (parseKeyCode(e)) {
      case keyCodes.ESCAPE:
        this.props.closeCarousel();
        break;
      case keyCodes.ARROW_LEFT:
        this.navigatePrev();
        break;
      case keyCodes.ARROW_RIGHT:
        this.navigateNext();
        break;
      case keyCodes.LETTER_K:
        this.navigatePrev();
        break;
      case keyCodes.LETTER_J:
        this.navigateNext();
        break;
    }
  }

  currentPhoto() {
    return this.props.photoData[this.state.currentPhotoIndex];
  }

  applyRotation(style) {
    const degrees = this.currentPhoto().rotate || 0;

    if (degrees === 0) {
      return;
    }

    style.transform = `rotate(${degrees}deg)`;
  }

  setPhotoUrl(style) {
    style.backgroundImage = `url(${this.currentPhoto().url})`;
  }

  navigateNext() {
    let newIndex = this.state.currentPhotoIndex + 1;
    if (newIndex >= this.props.photoData.length) {
      newIndex = 0;
    }

    this.setState({ currentPhotoIndex: newIndex });
  }

  navigatePrev() {
    let newIndex = this.state.currentPhotoIndex - 1;
    if (newIndex < 0) {
      newIndex = this.props.photoData.length - 1;
    }

    this.setState({ currentPhotoIndex: newIndex });
  }

  render() {
    const imgStyle = {};
    this.applyRotation(imgStyle);
    this.setPhotoUrl(imgStyle);

    return (
      <div className="photo-carousel">
        <div className="photo-carousel__current-photo" data-id={this.currentPhoto().id} style={imgStyle}>
        </div>

        <div className="photo-carousel__close" onClick={this.props.closeCarousel}>
          <IconX size="16" />
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
    );
  }

}

export default PhotoCarousel;
