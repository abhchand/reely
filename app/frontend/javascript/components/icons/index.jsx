/* eslint max-len: "off" */

import PropTypes from 'prop-types';
import React from 'react';

class IconCollection extends React.Component {

  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string
  };

  static defaultProps = {
    fillColor: '#EEEEEE',
    size: '32'
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 100 100" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <g id="Artboard" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
          <g id="collection" transform="translate(5.000000, -0.000000)" stroke={this.props.fillColor} strokeWidth="1.06382979">
            <g id="collection-2" transform="translate(6.000000, 4.000000)">
              <path d="M79.5319149,0.531914894 L79.5319149,89.8723404 C79.5319149,91.3411828 78.3411828,92.5319149 76.8723404,92.5319149 L0.531914894,92.5319149 L0.531914894,93.8723404 C0.531914894,94.7536459 1.24635412,95.4680851 2.12765957,95.4680851 L82.8723404,95.4680851 C83.7536459,95.4680851 84.4680851,94.7536459 84.4680851,93.8723404 L84.4680851,2.12765957 C84.4680851,1.24635412 83.7536459,0.531914894 82.8723404,0.531914894 L79.5319149,0.531914894 Z" id="Combined-Shape" />
            </g>
            <g id="collection-1">
              <rect id="background" x="0.531914894" y="0.531914894" width="83.9361702" height="94.9361702" rx="2.12765957" />
              <rect id="window-4" x="47.8125" y="48" width="31.875" height="32" rx="2.12765957" />
              <rect id="window-3" x="5.3125" y="48" width="31.875" height="32" rx="2.12765957" />
              <rect id="window-2" x="47.8125" y="5.33333333" width="31.875" height="32" rx="2.12765957" />
              <rect id="window-1" x="5.3125" y="5.33333333" width="31.875" height="32" rx="2.12765957" />
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
  };

  static defaultProps = {
    fillColor: '#EEEEEE',
    size: '32'
  }

  render() {
    return (
      // Icons/arrow-thick-left.svg
      <svg width={this.props.size} height={this.props.size} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 8 8">
        <path d="M3 0l-3 3.03 3 2.97v-2h5v-2h-5v-2z" transform="translate(0 1)" fill={this.props.fillColor} />
      </svg>
    );
  }

}

class IconArrowThickRight extends React.Component {

  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string
  };

  static defaultProps = {
    fillColor: '#EEEEEE',
    size: '32'
  }

  render() {
    return (
      // Icons/arrow-thick-right.svg
      <svg width={this.props.size} height={this.props.size} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 8 8">
        <path d="M5 0v2h-5v2h5v2l3-3.03-3-2.97z" transform="translate(0 1)" fill={this.props.fillColor} />
      </svg>
    );
  }

}

class IconCheckMark extends React.Component {

  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string
  };

  static defaultProps = {
    fillColor: '#EEEEEE',
    size: '32'
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 100 100" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <g id="icon-check-mark" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
          <path d="M34.515206,64.5123812 L22.8508108,52.8441027 C22.2651825,52.2582891 22.2652575,51.308671 22.8509785,50.7229501 L22.8508108,50.7227824 L29.2147718,44.3588213 C29.8005582,43.7730349 30.7503057,43.7730349 31.3360921,44.3588213 L43.0029419,56.0256711 L90.0226009,9.01169393 C90.6083976,8.42596679 91.5580965,8.42599494 92.1438584,9.01175682 L92.1439213,9.01169393 L98.5078823,15.375655 C99.0936688,15.9614414 99.0936688,16.9111889 98.5078823,17.4969753 L43,73.0048576 L34.5113646,64.5162222 Z" id="check-mark" fill={this.props.fillColor} />
          <path d="M81.8913561,11.4892946 L75.4926012,17.8867855 C68.4939276,12.3235621 59.6350936,9 50,9 C27.3563253,9 9,27.3563253 9,50 C9,72.6436747 27.3563253,91 50,91 C72.6436747,91 91,72.6436747 91,50 C91,44.2947767 89.8347014,38.8617235 87.7291338,33.92587 L94.4918898,27.163114 C98.0126877,34.0086966 100,41.7722675 100,50 C100,77.6142375 77.6142375,100 50,100 C22.3857625,100 0,77.6142375 0,50 C0,22.3857625 22.3857625,0 50,0 C62.12167,0 73.235866,4.31350886 81.8913561,11.4892946 Z" id="circle" fill={this.props.fillColor} />
        </g>
      </svg>
    );
  }

}

class IconCircle extends React.Component {

  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string
  };

  static defaultProps = {
    fillColor: '#EEEEEE',
    size: '32'
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 32 32" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <g id="Page-1" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
          <g id="Artboard-8" stroke={this.props.fillColor}>
            <circle id="Oval-3" cx="16" cy="16" r="15.5" />
          </g>
        </g>
      </svg>
    );
  }

}

class IconCopy extends React.Component {

  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string,
    foregroundFillColor: PropTypes.string
  };

  static defaultProps = {
    fillColor: '#EEEEEE',
    foregroundFillColor: '#FFFFFF',
    size: '32'
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 100 100" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <g id="icon-copy" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
          <g id="page-2" transform="translate(28.000000, 6.000000)" stroke={this.props.fillColor}>
            <path d="M2,5.50917336e-15 L45,1.23956401e-13 L57,12 L57,75 C57,76.1045695 56.1045695,77 55,77 L2,77 C0.8954305,77 -1.76282976e-14,76.1045695 -1.77635684e-14,75 L-2.33146835e-14,2 C-2.34499543e-14,0.8954305 0.8954305,2.02906125e-16 2,0 Z" id="page" strokeWidth="2" />
            <g id="corner" transform="translate(44.500000, 0.000000)" strokeLinecap="square">
              <path d="M0.5,12 L12.5,12" id="horizontal-line" />
              <path d="M0.5,-8.8817842e-16 L0.5,12" id="vertical-line" />
            </g>
          </g>
          <g id="page-1" transform="translate(18.000000, 15.000000)" stroke={this.props.fillColor}>
            <path d="M2,5.50917336e-15 L45,1.23956401e-13 L57,12 L57,75 C57,76.1045695 56.1045695,77 55,77 L2,77 C0.8954305,77 -1.76282976e-14,76.1045695 -1.77635684e-14,75 L-2.33146835e-14,2 C-2.34499543e-14,0.8954305 0.8954305,2.02906125e-16 2,0 Z" id="page" strokeWidth="2" fill={this.props.foregroundFillColor} />
            <g id="corner" transform="translate(44.500000, 0.000000)" strokeLinecap="square">
              <path d="M0.5,12 L12.5,12" id="horizontal-line" />
              <path d="M0.5,-8.8817842e-16 L0.5,12" id="vertical-line" />
            </g>
          </g>
        </g>
      </svg>
    );
  }

}

class IconDownload extends React.Component {

  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string,
    title: PropTypes.string
  };

  static defaultProps = {
    size: "32",
    fillColor: "#EEEEEE",
    title: "Download"
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 100 100" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <title>{this.props.title}</title>
        <g id="icon-download" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
          <polygon id="base" fill={this.props.fillColor} points="100 65 100 100 0 100 0 65 10 65 10 90 90 90 90 65"></polygon>
          <polygon id="arrow" fill={this.props.fillColor} points="58 47 78 47 50 79 22 47 42 47 42 0 58 0"></polygon>
        </g>
      </svg>
    );
  }

}

class IconFile extends React.Component {

  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string,
    secondaryColor: PropTypes.string,
    title: PropTypes.string
  };

  static defaultProps = {
    fillColor: '#EEEEEE',
    secondaryColor: '#FFFFFF',
    size: '32',
    title: 'File'
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 100 100" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <title>{this.props.title}</title>
        <g id="icon-file" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
          <path d="M87.5,31.0355339 L58.9644661,2.5 L13,2.5 C12.7238576,2.5 12.5,2.72385763 12.5,3 L12.5,97 C12.5,97.2761424 12.7238576,97.5 13,97.5 L87,97.5 C87.2761424,97.5 87.5,97.2761424 87.5,97 L87.5,31.0355339 Z" id="base" stroke={this.props.fillColor} strokeWidth="5" fill={this.props.fillColor}></path>
          <path d="M60.5,1.20710678 L60.5,27 C60.5,28.3807119 61.6192881,29.5 63,29.5 L88.7928932,29.5 L60.5,1.20710678 Z" id="fold" stroke={this.props.secondaryColor} fill={this.props.secondaryColor}></path>
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
  };

  static defaultProps = {
    fillColor: '#EEEEEE',
    size: '32',
    strokeColor: '#EEEEEE'
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 32 32" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <g id="Page-1" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
          <g id="Artboard-8">
            <g id="Oval-3">
              <circle fill={this.props.fillColor} fillRule="evenodd" cx="16" cy="16" r="16" />
              <circle stroke={this.props.strokeColor} strokeWidth="1" cx="16" cy="16" r="15.5" />
            </g>
          </g>
        </g>
      </svg>
    );
  }

}

class IconLoading extends React.Component {

  static propTypes = {
    size: PropTypes.string,
    backgroundFillColor: PropTypes.string,
    foregroundFillColor: PropTypes.string
  };

  static defaultProps = {
    size: '32',
    backgroundFillColor: '#D8D8D8',
    foregroundFillColor: '#979797'
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 100 100" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <title>{this.props.title}</title>
        <g id="icon-loading" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
          <path d="M50,100 C22.3857625,100 0,77.6142375 0,50 C0,22.3857625 22.3857625,0 50,0 C77.6142375,0 100,22.3857625 100,50 C100,77.6142375 77.6142375,100 50,100 Z M50,90 C72.09139,90 90,72.09139 90,50 C90,27.90861 72.09139,10 50,10 C27.90861,10 10,27.90861 10,50 C10,72.09139 27.90861,90 50,90 Z" id="base" fill={this.props.backgroundFillColor}></path>
          <path d="M15,14.6446609 C24.0482203,5.59644063 36.5482203,-7.10542736e-15 50.3553391,-7.10542736e-15 C64.1624578,-7.10542736e-15 76.6624578,5.59644063 85.7106781,14.6446609 L78.6396103,21.7157288 C71.4010341,14.4771525 61.4010341,10 50.3553391,10 C39.3096441,10 29.3096441,14.4771525 22.0710678,21.7157288 L15,14.6446609 Z" id="rotator" fill={this.props.foregroundFillColor}></path>
        </g>
      </svg>
    );
  }

}

class IconPencilWithSquares extends React.Component {

  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string
  };

  static defaultProps = {
    fillColor: '#EEEEEE',
    size: '32'
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 32 32" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <g id="Page-1" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
          <g id="Artboard-7">
            <g id="Group-2" transform="translate(0.250000, 1.250000)">
              <g id="pencil" transform="translate(15.483871, 14.967742) rotate(-45.000000) translate(-15.483871, -14.967742) translate(3.096774, 11.354839)">
                <path d="M22.6199158,1.20430108 C23.8096906,1.20430108 24.7741935,2.28266899 24.7741935,3.61290323 C24.7741935,4.94313746 23.8096906,6.02150538 22.6199158,6.02150538 L22.6199158,1.20430108 Z" id="Combined-Shape" fill={this.props.fillColor} />
                <g id="Group" transform="translate(3.769986, 0.000000)" stroke={this.props.fillColor} strokeWidth="1.04347826" strokeLinecap="square">
                  <path d="M1.61570827,1.80645161 L17.772791,1.80645161" id="Line" />
                  <path d="M1.61570827,3.61290323 L17.772791,3.61290323" id="Line" />
                  <path d="M1.61570827,5.41935484 L17.772791,5.41935484" id="Line" />
                  <path d="M17.772791,1.80645161 L17.772791,4.21505376" id="Line" />
                  <path d="M1.61570827,1.80645161 L1.61570827,4.21505376" id="Line" />
                </g>
                <path d="M-0.254324451,3.61290323 L4.56287985,1.45862553 L4.56287985,5.76718093 L-0.254324451,3.61290323 Z M2.02711547,3.61290323 L4.43571763,4.69004208 L4.43571763,2.53576438 L2.02711547,3.61290323 Z" id="Combined-Shape" fill={this.props.fillColor} />
              </g>
              <rect id="Rectangle-3" stroke={this.props.fillColor} x="0.5" y="3.84859016" width="27.6099177" height="24.5546356" rx="2" />
              <rect id="Rectangle-3" stroke={this.props.fillColor} x="3.22475406" y="1.0091862" width="27.6099177" height="24.5546356" rx="2" />
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
    title: PropTypes.string
  };

  static defaultProps = {
    fillColor: '#EEEEEE',
    size: '32'
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 100 100" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <title>{this.props.title}</title>
        <g id="icon-plus" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
          <rect id="vertical" fill={this.props.fillColor} x="45" y="0" width="10" height="100" />
          <rect id="horizontal" fill={this.props.fillColor} x="0" y="45" width="100" height="10" />
        </g>
      </svg>
    );
  }

}

class IconRefresh extends React.Component {

  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string
  };

  static defaultProps = {
    fillColor: '#EEEEEE',
    size: '32'
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 100 100" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <g id="icon-refresh" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
          <path d="M35.5764413,7.36126098 L38.2645075,15.04145 C23.5615994,20.1139791 13,34.0735927 13,50.5 C13,71.2106781 29.7893219,88 50.5,88 C71.2106781,88 88,71.2106781 88,50.5 C88,34.0735927 77.4384006,20.1139791 62.7354925,15.04145 L65.3144338,7.67304628 C82.6278758,13.9384955 95,30.5244156 95,50 C95,74.8528137 74.8528137,95 50,95 C25.1471863,95 5,74.8528137 5,50 C5,30.191978 17.7980998,13.3731124 35.5764413,7.36126098 Z" id="Combined-Shape" fill={this.props.fillColor} transform="translate(50.000000, 51.180630) rotate(19.000000) translate(-50.000000, -51.180630) " />
          <polygon id="Triangle" fill={this.props.fillColor} transform="translate(56.000000, 9.500000) rotate(90.000000) translate(-56.000000, -9.500000) " points="56 3.5 65 15.5 47 15.5" />
        </g>
      </svg>
    );
  }

}

class IconRemovePhoto extends React.Component {
  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string,
    title: PropTypes.string
  };

  static defaultProps = {
    size: '32',
    fillColor: '#EEEEEE',
    title: 'Remove Icon'
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 100 100" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <title>{this.props.title}</title>
        <g id="icon-remove-photo" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
          <g id="photo" transform="translate(4.000000, 0.000000)">
            <rect id="frame" stroke={this.props.fillColor} strokeWidth="10" fill="#FFFFFF" x="5" y="5" width="65" height="90" rx="3"></rect>
            <polygon id="mountains" fill={this.props.fillColor} transform="translate(37.500000, 59.000000) scale(-1, 1) translate(-37.500000, -59.000000) " points="10 48.7058824 24 28 41.0869565 51 54 41 65 51 65 90 10 90"></polygon>
            <circle id="sun" fill={this.props.fillColor} cx="30" cy="25" r="5"></circle>
          </g>
          <g id="x-icon" transform="translate(50.000000, 50.000000)">
            <circle id="outer-circle" fill={this.props.fillColor} cx="25" cy="25" r="25"></circle>
            <circle id="inner-circle" fill="#FFFFFF" cx="25" cy="25" r="15"></circle>
            <rect id="x-2" fill={this.props.fillColor} transform="translate(24.760321, 24.760321) rotate(-45.000000) translate(-24.760321, -24.760321) " x="22.5864075" y="11.7168423" width="4.34782609" height="26.0869565"></rect>
            <rect id="x-1" fill={this.props.fillColor} transform="translate(24.760321, 24.760321) rotate(45.000000) translate(-24.760321, -24.760321) " x="22.5864075" y="11.7168423" width="4.34782609" height="26.0869565"></rect>
          </g>
        </g>
      </svg>
    )
  }
}

class IconTrash extends React.Component {

  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string,
    title: PropTypes.string
  };

  static defaultProps = {
    fillColor: '#EEEEEE',
    size: '32',
    title: 'Trash Icon'
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 32 32" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <title>{this.props.title}</title>
        <defs></defs>
        <g id="Page-1" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd" strokeLinecap="square">
          <g id="Artboard-3" stroke={this.props.fillColor} strokeWidth="1.39655172">
            <g id="Group" transform="translate(4.500000, -2.000000)">
              <path d="M8.64379085,9.54310345 L8.64379085,33.2844828" id="Line"></path>
              <path d="M2.92611111,8.76724138 L2.92611111,32.5086207" id="Line"></path>
              <path d="M2.93137255,33.2844828 L20.0686275,33.2844828" id="Line"></path>
              <path d="M14.3562092,9.54310345 L14.3562092,33.2844828" id="Line"></path>
              <path d="M20.0738889,8.76724138 L20.0738889,32.5086207" id="Line"></path>
              <path d="M0.0751633987,8.14655172 L22.9248366,8.14655172" id="Line"></path>
              <path d="M0.0766666667,6.98275862 L22.9233333,6.98275862" id="Line"></path>
              <path d="M7.21568627,5.50862069 L7.21568627,4.11206897" id="Line"></path>
              <path d="M15.7843137,5.50862069 L15.7843137,4.11206897" id="Line"></path>
              <path d="M8.64379085,2.71551724 L14.3562092,2.71551724" id="Line"></path>
            </g>
          </g>
        </g>
      </svg>
    );
  }

}

class IconUserWithKey extends React.Component {

  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string
  };

  static defaultProps = {
    fillColor: '#EEEEEE',
    size: '32'
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 100 100" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <title>{this.props.title}</title>
        <g id="icon-users" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd">
          <path d="M7,81.3559322 C7,62.0479403 19.9975977,45.7561832 37.7736624,40.646951 C31.5804942,36.7387584 27.4705882,29.8632027 27.4705882,22.0338983 C27.4705882,9.86491229 37.3993323,0 49.6470588,0 C61.8947853,0 71.8235294,9.86491229 71.8235294,22.0338983 C71.8235294,29.8632027 67.7136234,36.7387584 61.5204552,40.646951 C79.2965199,45.7561832 92.2941176,62.0479403 92.2941176,81.3559322 L92.2941176,91.5254237 C73.3398693,97.1751412 59.124183,100 49.6470588,100 C40.1699346,100 25.9542484,97.1751412 7,91.5254237 L7,81.3559322 Z" id="person" fill={this.props.fillColor}></path>
          <circle id="bubble" stroke={this.props.fillColor} strokeWidth="3" fill="#FFFFFF" cx="22.5" cy="77.5" r="21"></circle>
          <g id="key" transform="translate(10.000000, 65.000000)">
            <polygon id="ridges" fill={this.props.fillColor} points="13 9 0 24 0 26 6 26 6 22 11 22 11 17 16 17 19 15"></polygon>
            <circle id="head" fill={this.props.fillColor} cx="20" cy="8" r="8"></circle>
            <circle id="hole" fill="#FFFFFF" cx="21" cy="7" r="2"></circle>
          </g>
        </g>
      </svg>
    );
  }

}

class IconX extends React.Component {

  static propTypes = {
    size: PropTypes.string,
    fillColor: PropTypes.string,
    title: PropTypes.string
  };

  static defaultProps = {
    fillColor: '#EEEEEE',
    size: '32',
    title: 'X Icon'
  }

  render() {
    return (
      <svg width={this.props.size} height={this.props.size} viewBox="0 0 32 32" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <title>{this.props.title}</title>
        <g id="Page-1" stroke="none" strokeWidth="1" fill="none" fillRule="evenodd" strokeLinecap="square">
          <g id="Artboard-2" stroke={this.props.fillColor} strokeWidth="2">
            <g id="Group" transform="translate(3.000000, 2.000000)">
              <path d="M0.5,26.5 L25.5,0.5" id="Line" />
              <path d="M0.5,26.5 L25.5,0.5" id="Line" transform="translate(13.000000, 13.500000) scale(1, -1) translate(-13.000000, -13.500000) " />
            </g>
          </g>
        </g>
      </svg>
    );
  }

}

export {
  IconCollection, IconArrowThickLeft, IconArrowThickRight, IconCheckMark,
  IconCircle, IconCopy, IconDownload, IconFile, IconFilledCircle, IconLoading,
  IconPencilWithSquares, IconPlus, IconRefresh, IconRemovePhoto, IconTrash,
  IconUserWithKey, IconX
};
