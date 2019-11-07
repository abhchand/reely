import PropTypes from "prop-types";
import React from "react";

class ActionNotification extends React.Component {
  static propTypes = {
    notification: PropTypes.object.isRequired,
    duration: PropTypes.number,
    isDismissable: PropTypes.bool,
    closeButtonLabel: PropTypes.string,
    onClose: PropTypes.func.isRequired
  };

  static defaultProps = {
    duration: 5000,
    isDismissable: true,
    closeButtonLabel: "Close"
  };

  static notificationTypes = {
    error: "notification--error",
    info: "notification--info",
    success: "notification--success"
  }

  constructor(props) {
    super(props);

    this.notificationContent = this.notificationContent.bind(this);
    this.notificationClass = this.notificationClass.bind(this);
    this.pauseTimer = this.pauseTimer.bind(this);
    this.resumeTimer = this.resumeTimer.bind(this);
    this.closeButton = this.closeButton.bind(this);
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

    if (typeof content === "string" || content instanceof String) {
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
    this.remaining -= (Date.now() - this.start);
  }

  resumeTimer() {
    clearTimeout(this.timer);

    this.start = Date.now();
    this.timer = setTimeout(this.props.onClose, this.remaining);
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
          onClick={this.props.onClose}>
          {label}
        </button>
      );
    }

    return null;
  }

  render() {
    return(
      <div
        data-testid={`notification-${this.props.notification.id}`}
        className={`notification ${this.notificationClass()}`}
        onMouseEnter={this.pauseTimer}
        onMouseLeave={this.resumeTimer}>
        {this.notificationContent()}
        {this.closeButton()}
      </div>
    );
  }
}

export default ActionNotification;