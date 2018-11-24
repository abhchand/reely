import PropTypes from "prop-types";
import React from "react";

class IconArrowThickLeft extends React.Component {
  static propTypes = {
    size: React.PropTypes.string,
    fillColor: React.PropTypes.string
  }

  constructor(props) {
    super(props);

    this.state = {
      size: "32",
      fillColor: "#EEEEEE"
    }
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
    size: React.PropTypes.string,
    fillColor: React.PropTypes.string
  }

  constructor(props) {
    super(props);

    this.state = {
      size: "32",
      fillColor: "#EEEEEE"
    }
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
    size: React.PropTypes.string,
    fillColor: React.PropTypes.string
  }

  constructor(props) {
    super(props);

    this.state = {
      size: "32",
      fillColor: "#EEEEEE"
    }
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 32 32" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <g id="Page-1" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
          <g id="Artboard-6" fill={this.props.fillColor}>
            <path d="M14.5810225,21.4535604 C14.7483703,21.4100207 14.90653,21.3223046 15.0377989,21.1910358 L22.6564144,13.5724202 C23.0438935,13.1849411 23.0459704,12.5437672 22.6517873,12.1495842 L21.2508234,10.7486202 C20.8505898,10.3483867 20.2196149,10.3523655 19.8279873,10.7439931 L13.743097,16.8288834 L11.9209299,15.0067163 C11.5266963,14.6124827 10.8914905,14.6085095 10.4958207,15.0041793 L9.50417927,15.9958207 C9.11134683,16.3886532 9.108137,17.0223506 9.50671635,17.4209299 L13.3719633,21.2861769 C13.7003553,21.6145689 14.1959506,21.6721711 14.5810225,21.4535604 Z M16,29 C8.82029825,29 3,23.1797017 3,16 C3,8.82029825 8.82029825,3 16,3 C23.1797017,3 29,8.82029825 29,16 C29,23.1797017 23.1797017,29 16,29 Z" id="Combined-Shape"></path>
          </g>
        </g>
      </svg>
    );
  }
}

class IconCircle extends React.Component {
  static propTypes = {
    size: React.PropTypes.string,
    fillColor: React.PropTypes.string
  }

  constructor(props) {
    super(props);

    this.state = {
      size: "32",
      fillColor: "#EEEEEE"
    }
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
    size: React.PropTypes.string,
    fillColor: React.PropTypes.string
  }

  constructor(props) {
    super(props);

    this.state = {
      size: "32",
      fillColor: "#EEEEEE",
      strokeColor: "#EEEEEE"
    }
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 32 32" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <g id="Page-1" stroke="none" stroke-width="1" fill="none" fillRule="evenodd">
          <g id="Artboard-8">
            <g id="Oval-3">
              <circle fill={this.props.fillColor} fillRule="evenodd" cx="16" cy="16" r="16"></circle>
              <circle stroke={this.props.strokeColor} stroke-width="1" cx="16" cy="16" r="15.5"></circle>
            </g>
          </g>
        </g>
      </svg>
    );
  }
}

class IconPencilWithSquares extends React.Component {
  static propTypes = {
    size: React.PropTypes.string,
    fillColor: React.PropTypes.string
  }

  constructor(props) {
    super(props);

    this.state = {
      size: "32",
      fillColor: "#EEEEEE"
    }
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

class IconX extends React.Component {
  static propTypes = {
    size: React.PropTypes.string,
    fillColor: React.PropTypes.string
  }

  constructor(props) {
    super(props);

    this.state = {
      size: "32",
      fillColor: "#EEEEEE"
    }
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
  IconArrowThickLeft, IconArrowThickRight, IconCheckMark, IconCircle,
  IconFilledCircle, IconPencilWithSquares, IconX
};
