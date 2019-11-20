import { CSSTransition } from 'react-transition-group';
import PropTypes from 'prop-types';
import React from 'react';

class ActionNotification extends React.Component {

  static propTypes = {
    notification: PropTypes.object.isRequired,
    duration: PropTypes.number,
    isDismissable: PropTypes.bool,
    closeButtonLabel: PropTypes.string,
    onClose: PropTypes.func.isRequired
  };

  static defaultProps = {
    closeButtonLabel: 'Close',
    duration: 5000,
    isDismissable: true
  };

  static notificationTypes = {
    error: 'notification--error',
    info: 'notification--info',
    success: 'notification--success'
  }

  constructor(props) {
    super(props);

    this.notificationContent = this.notificationContent.bind(this);
    this.notificationClass = this.notificationClass.bind(this);
    this.pauseTimer = this.pauseTimer.bind(this);
    this.resumeTimer = this.resumeTimer.bind(this);
    this.closeButton = this.closeButton.bind(this);
    this.onClose = this.onClose.bind(this);

    this.state = {
      inProp: true
    };
  }

  componentDidMount() {
    this.remaining = this.props.duration;
    this.resumeTimer();
  }

  componentWillUnmount() {
    clearTimeout(this.timer);
  }

  notificationContent() {
    const content = this.props.notification.content;

    if (typeof content === 'string' || content instanceof String) {
      return <span>{content}</span>;
    }

    return content;
  }

  notificationClass() {
    const type = this.props.notification.type;
    return ActionNotification.notificationTypes[type] || ActionNotification.notificationTypes.success;
  }

  pauseTimer() {
    clearTimeout(this.timer);
    this.remaining -= Date.now() - this.start;
  }

  resumeTimer() {
    clearTimeout(this.timer);

    this.start = Date.now();
    this.timer = setTimeout(this.onClose, this.remaining);
  }

  closeButton() {
    if (this.props.isDismissable) {
      const label = this.props.closeButtonLabel;

      return (
        <button
          data-testid={`notification-${this.props.notification.id}-close-btn`}
          type="button"
          className="close-btn"
          title={label}
          onClick={this.onClose}>
          {label}
        </button>
      );
    }

    return null;
  }

  onClose() {
    this.setState({ inProp: false });
    this.props.onClose();
  }

  // eslint-disable-next-line padded-blocks
  render() {

    /*
     * Note: The transition timeouts need to be specified both here and in the
     * CSS. From the React docs:
     *
     *    You’ll notice that animation durations need to be specified in
     *    both the CSS and the render method; this tells React when to remove
     *    the animation classes from the element and — if it’s leaving — when
     *    to remove the element from the DOM.
     *
     * See: https://reactjs.org/docs/animation.html
     */

    return (
      <CSSTransition classNames="action-notifications-group" in={this.state.inProp} unmountOnExit timeout={500}>
        <div
          data-testid={`notification-${this.props.notification.id}`}
          className={`notification ${this.notificationClass()}`}
          onMouseEnter={this.pauseTimer}
          onMouseLeave={this.resumeTimer}>
          {this.notificationContent()}
          {this.closeButton()}
        </div>
      </CSSTransition>
    );
  }
}

export default ActionNotification;
