/* eslint max-len: "off" */

import PropTypes from "prop-types";
import React from "react";

class IconCollection extends React.Component {
  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string
  }

  constructor(props) {
    super(props);

    this.state = {
      size: "32",
      fillColor: "#EEEEEE"
    };
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 100 100" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <g id="Artboard" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
          <g id="collection" transform="translate(5.000000, -0.000000)" stroke={this.props.fillColor} strokeWidth="1.06382979">
            <g id="collection-2" transform="translate(6.000000, 4.000000)">
              <path d="M79.5319149,0.531914894 L79.5319149,89.8723404 C79.5319149,91.3411828 78.3411828,92.5319149 76.8723404,92.5319149 L0.531914894,92.5319149 L0.531914894,93.8723404 C0.531914894,94.7536459 1.24635412,95.4680851 2.12765957,95.4680851 L82.8723404,95.4680851 C83.7536459,95.4680851 84.4680851,94.7536459 84.4680851,93.8723404 L84.4680851,2.12765957 C84.4680851,1.24635412 83.7536459,0.531914894 82.8723404,0.531914894 L79.5319149,0.531914894 Z" id="Combined-Shape"></path>
            </g>
            <g id="collection-1">
              <rect id="background" x="0.531914894" y="0.531914894" width="83.9361702" height="94.9361702" rx="2.12765957"></rect>
              <rect id="window-4" x="47.8125" y="48" width="31.875" height="32" rx="2.12765957"></rect>
              <rect id="window-3" x="5.3125" y="48" width="31.875" height="32" rx="2.12765957"></rect>
              <rect id="window-2" x="47.8125" y="5.33333333" width="31.875" height="32" rx="2.12765957"></rect>
              <rect id="window-1" x="5.3125" y="5.33333333" width="31.875" height="32" rx="2.12765957"></rect>
            </g>
          </g>
        </g>
      </svg>
    );
  }
}

class IconArrowThickLeft extends React.Component {
  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string
  }

  constructor(props) {
    super(props);

    this.state = {
      size: "32",
      fillColor: "#EEEEEE"
    };
  }

  render() {
    return (
      // icons/arrow-thick-left.svg
      <svg width={this.props.size} height={this.props.size} xmlns="http://www.w3.org/2000/svg"viewBox="0 0 8 8">
        <path d="M3 0l-3 3.03 3 2.97v-2h5v-2h-5v-2z" transform="translate(0 1)" fill={this.props.fillColor}></path>
      </svg>
    );
  }
}

class IconArrowThickRight extends React.Component {
  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string
  }

  constructor(props) {
    super(props);

    this.state = {
      size: "32",
      fillColor: "#EEEEEE"
    };
  }

  render() {
    return (
      // icons/arrow-thick-right.svg
      <svg width={this.props.size} height={this.props.size} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 8 8">
        <path d="M5 0v2h-5v2h5v2l3-3.03-3-2.97z" transform="translate(0 1)" fill={this.props.fillColor}></path>
      </svg>
    );
  }
}

class IconCheckMark extends React.Component {
  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string
  }

  constructor(props) {
    super(props);

    this.state = {
      size: "32",
      fillColor: "#EEEEEE"
    };
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 100 100" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <g id="icon-check-mark" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
          <path d="M34.515206,64.5123812 L22.8508108,52.8441027 C22.2651825,52.2582891 22.2652575,51.308671 22.8509785,50.7229501 L22.8508108,50.7227824 L29.2147718,44.3588213 C29.8005582,43.7730349 30.7503057,43.7730349 31.3360921,44.3588213 L43.0029419,56.0256711 L90.0226009,9.01169393 C90.6083976,8.42596679 91.5580965,8.42599494 92.1438584,9.01175682 L92.1439213,9.01169393 L98.5078823,15.375655 C99.0936688,15.9614414 99.0936688,16.9111889 98.5078823,17.4969753 L43,73.0048576 L34.5113646,64.5162222 Z" id="check-mark" fill={this.props.fillColor}></path>
          <path d="M81.8913561,11.4892946 L75.4926012,17.8867855 C68.4939276,12.3235621 59.6350936,9 50,9 C27.3563253,9 9,27.3563253 9,50 C9,72.6436747 27.3563253,91 50,91 C72.6436747,91 91,72.6436747 91,50 C91,44.2947767 89.8347014,38.8617235 87.7291338,33.92587 L94.4918898,27.163114 C98.0126877,34.0086966 100,41.7722675 100,50 C100,77.6142375 77.6142375,100 50,100 C22.3857625,100 0,77.6142375 0,50 C0,22.3857625 22.3857625,0 50,0 C62.12167,0 73.235866,4.31350886 81.8913561,11.4892946 Z" id="circle" fill={this.props.fillColor}></path>
        </g>
      </svg>
    );
  }
}

class IconCircle extends React.Component {
  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string
  }

  constructor(props) {
    super(props);

    this.state = {
      size: "32",
      fillColor: "#EEEEEE"
    };
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 32 32" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <g id="Page-1" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
          <g id="Artboard-8" stroke={this.props.fillColor}>
            <circle id="Oval-3" cx="16" cy="16" r="15.5"></circle>
          </g>
        </g>
      </svg>
    );
  }
}

class IconFilledCircle extends React.Component {
  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string,
    strokeColor: PropTypes.string
  }

  constructor(props) {
    super(props);

    this.state = {
      size: "32",
      fillColor: "#EEEEEE",
      strokeColor: "#EEEEEE"
    };
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 32 32" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <g id="Page-1" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
          <g id="Artboard-8">
            <g id="Oval-3">
              <circle fill={this.props.fillColor} fillRule="evenodd" cx="16" cy="16" r="16"></circle>
              <circle stroke={this.props.strokeColor} strokeWidth="1" cx="16" cy="16" r="15.5"></circle>
            </g>
          </g>
        </g>
      </svg>
    );
  }
}

class IconPencilWithSquares extends React.Component {
  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string
  }

  constructor(props) {
    super(props);

    this.state = {
      size: "32",
      fillColor: "#EEEEEE"
    };
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 32 32" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <g id="Page-1" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
          <g id="Artboard-7">
            <g id="Group-2" transform="translate(0.250000, 1.250000)">
              <g id="pencil" transform="translate(15.483871, 14.967742) rotate(-45.000000) translate(-15.483871, -14.967742) translate(3.096774, 11.354839)">
                <path d="M22.6199158,1.20430108 C23.8096906,1.20430108 24.7741935,2.28266899 24.7741935,3.61290323 C24.7741935,4.94313746 23.8096906,6.02150538 22.6199158,6.02150538 L22.6199158,1.20430108 Z" id="Combined-Shape" fill={this.props.fillColor}></path>
                <g id="Group" transform="translate(3.769986, 0.000000)" stroke={this.props.fillColor} strokeWidth="1.04347826" strokeLinecap="square">
                  <path d="M1.61570827,1.80645161 L17.772791,1.80645161" id="Line"></path>
                  <path d="M1.61570827,3.61290323 L17.772791,3.61290323" id="Line"></path>
                  <path d="M1.61570827,5.41935484 L17.772791,5.41935484" id="Line"></path>
                  <path d="M17.772791,1.80645161 L17.772791,4.21505376" id="Line"></path>
                  <path d="M1.61570827,1.80645161 L1.61570827,4.21505376" id="Line"></path>
                </g>
                <path d="M-0.254324451,3.61290323 L4.56287985,1.45862553 L4.56287985,5.76718093 L-0.254324451,3.61290323 Z M2.02711547,3.61290323 L4.43571763,4.69004208 L4.43571763,2.53576438 L2.02711547,3.61290323 Z" id="Combined-Shape" fill={this.props.fillColor}></path>
              </g>
              <rect id="Rectangle-3" stroke={this.props.fillColor} x="0.5" y="3.84859016" width="27.6099177" height="24.5546356" rx="2"></rect>
              <rect id="Rectangle-3" stroke={this.props.fillColor} x="3.22475406" y="1.0091862" width="27.6099177" height="24.5546356" rx="2"></rect>
            </g>
          </g>
        </g>
      </svg>
    );
  }
}

class IconPlus extends React.Component {
  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string,
    strokeColor: PropTypes.string
  }

  constructor(props) {
    super(props);

    this.state = {
      size: "32",
      fillColor: "#EEEEEE",
      strokeColor: "#EEEEEE"
    };
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 100 100" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <g id="icon-plus" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
          <rect id="vertical" fill={this.props.fillColor} x="45" y="0" width="10" height="100"></rect>
          <rect id="horizontal" fill={this.props.fillColor} x="0" y="45" width="100" height="10"></rect>
        </g>
      </svg>
    );
  }
}

class IconX extends React.Component {
  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string
  }

  constructor(props) {
    super(props);

    this.state = {
      size: "32",
      fillColor: "#EEEEEE"
    };
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 32 32" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <title>Close Icon</title>
        <g id="Page-1" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd" strokeLinecap="square">
          <g id="Artboard-2" stroke={this.props.fillColor} strokeWidth="2">
            <g id="Group" transform="translate(3.000000, 2.000000)">
                <path d="M0.5,26.5 L25.5,0.5" id="Line"></path>
                <path d="M0.5,26.5 L25.5,0.5" id="Line" transform="translate(13.000000, 13.500000) scale(1, -1) translate(-13.000000, -13.500000) "></path>
            </g>
          </g>
        </g>
      </svg>
    );
  }
}

export {
  IconCollection, IconArrowThickLeft, IconArrowThickRight, IconCheckMark,
  IconCircle, IconFilledCircle, IconPencilWithSquares, IconPlus, IconX
};
