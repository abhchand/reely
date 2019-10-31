import ActionNotification from "./action_notification";
import mountReactComponent from "mount-react-component.jsx";
import PropTypes from "prop-types";
import React from "react";
import { CSSTransitionGroup } from "react-transition-group";

// Action Notifications are similar to flash notifications, with a few
// differences:
//    1. They are stylized differently
//    2. They and are implemented in React, not vanilla JS like flash
//       messages
//    3. They dissapear after a set timeout
//    4. They support multiple notifications displayed simultaneously
//
//  Notifications have the following object structure:
//
//  [
//    { id: "abcde", content: "foo", type: "error" },
//    { id: "fghij", content: "bar", isDismissable: false },
//    ....
//  ]
//
//   - id (required) - a unique id.
//   - content (required) - can be a simple string or can be a React Node
//     to be displayed within the message.
//   - type (optional) - Must be one outlined in the `<ActionNotification />`
//     component. Defaults to "success".
//   - isDismissable (optional) - If true displays a "Close" button that
//     dismisses the notification. Defaults to true.
//
//  Notifications can be passed in as props from the backend or they can be
//  set by other JS components on the frontend.
//
//  window.action_notifications.add({ id: "id", content: "sup", type: "info" });
//

class ActionNotifications extends React.Component {
  static propTypes = {
    notifications: PropTypes.array.isRequired,
    duration: PropTypes.number,
    isDismissable: PropTypes.bool,
    closeButtonLabel: PropTypes.string
  };

  constructor(props) {
    super(props);

    this.state = {
      notifications: props.notifications
    };

    window.action_notifications = this;
  }

  add(notification) {
    this.setState(function(prevState) {
      const notifications = prevState.notifications;
      notifications.push(notification);

      return { notifications: notifications };
    });
  }

  remove(notification) {
    this.setState(function(prevState) {
      const notifications = prevState.notifications;

      const index = this.state.notifications.indexOf(notification);
      notifications.splice(index, 1);

      return { notifications: notifications };
    });
  }

  render () {
    const self = this;

    const notifications = this.state.notifications.map(function(notification) {
      return (
        <ActionNotification
          key={notification.id}
          notification={notification}
          duration={self.props.duration}
          isDismissable={self.props.isDismissable}
          closeButtonLabel={self.props.closeButtonLabel}
          onClose={() => self.remove(notification)} /> // eslint-disable-line react/jsx-no-bind
      );
    });

    // Note: The transition timeouts need to be specified both here and in the
    // CSS. From the React docs:
    //
    //    You’ll notice that animation durations need to be specified in
    //    both the CSS and the render method; this tells React when to remove
    //    the animation classes from the element and — if it’s leaving — when
    //    to remove the element from the DOM.
    //
    // See: https://reactjs.org/docs/animation.html

    return(
      <div className="action-notifications">
        <CSSTransitionGroup
          transitionName="action-notifications-group"
          transitionAppear={false}
          transitionAppearTimeout={500}
          transitionEnter={true}
          transitionEnterTimeout={500}
          transitionLeave={true}
          transitionLeaveTimeout={500}>
          {notifications}
        </CSSTransitionGroup>
      </div>
    );
  }
}

export default ActionNotifications;

mountReactComponent(ActionNotifications, 'action-notifications');
