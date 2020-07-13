import { cleanup, render } from '@testing-library/react';
import ActionNotification from 'javascript/components/action_notifications/action_notification';
import ActionNotifications from 'javascript/components/action_notifications';
import React from 'react';

let notifications;

beforeEach(() => {
  jest.useFakeTimers();

  notifications = [
    { id: 'abcde', content: <div className="content">content</div>, type: 'error' },
    { id: 'fghij', content: 'other content', type: 'success' }
  ];
});

afterEach(cleanup);

describe('<ActionNotifications />', () => {
  it('renders the component', () => {
    const rendered = renderComponent();

    // Notification 1

    let actionNotification = rendered.getByTestId('notification-abcde');
    expect(actionNotification).toHaveClass('notification--error');

    let content = rendered.container.querySelector('.content');
    expect(content).toHaveTextContent('content');

    // Notification 2

    actionNotification = rendered.getByTestId('notification-fghij');
    expect(actionNotification).toHaveClass('notification--success');

    content = rendered.container.querySelector('span');
    expect(content).toHaveTextContent('other content');
  });

  describe('.add', () => {
    it('adds a notification to the group', () => {
      const rendered = renderComponent();

      let actionNotifications = rendered.container.querySelectorAll('.notification');
      expect(actionNotifications).toHaveLength(2);

      const newNotification = { id: 'klmno', content: 'new content', type: 'success' };
      window.action_notifications.add(newNotification);

      actionNotifications = rendered.container.querySelectorAll('.notification');
      expect(actionNotifications).toHaveLength(3);
    });

    it('handles notifications added at different times', () => {
      const rendered = renderComponent();

      let actionNotifications = rendered.container.querySelectorAll('.notification');
      expect(actionNotifications).toHaveLength(2);

      const newNotification = { id: 'klmno', content: 'new content', type: 'success' };
      window.action_notifications.add(newNotification);

      actionNotifications = rendered.container.querySelectorAll('.notification');
      expect(actionNotifications).toHaveLength(3);
    });
  });

  describe('closeButtonLabel prop', () => {
    it('sets the label on the children when present', () => {
      const rendered = renderComponent({ closeButtonLabel: 'Foo' });

      const closeButton = rendered.getByTestId('notification-abcde-close-btn');
      expect(closeButton).toHaveTextContent('Foo');
    });
  });

  describe('duration prop', () => {
    it('sets the duration on the children when present', () => {
      const rendered = renderComponent({ duration: 1500 });

      // 0.0 secs
      let actionNotifications = rendered.container.querySelectorAll('.notification');
      expect(actionNotifications).toHaveLength(2);

      /*
       * There's an additional 500ms `transitionLeaveTimeout` on the group
       * during which the component will still be present
       */

      // 1.5 secs
      jest.advanceTimersByTime(1500);
      actionNotifications = rendered.container.querySelectorAll('.notification');
      expect(actionNotifications).toHaveLength(2);

      // 2.0 secs
      jest.advanceTimersByTime(500);
      actionNotifications = rendered.container.querySelectorAll('.notification');
      expect(actionNotifications).toHaveLength(0);
    });
  });

  describe('isDismissable prop', () => {
    it('sets the isDismissable on the children when present', () => {

      /*
       * This test is written with the assumption that isDismissable is
       * TRUE by default. This is so that we can set `{isDismissable: false }`
       * on the parent and verify that the props are being set on the children.`
       */
      const defaultIsDismissable = ActionNotification.defaultProps.isDismissable;
      expect(defaultIsDismissable).toBeTruthy();

      const rendered = renderComponent({ isDismissable: false });

      const closeButton = rendered.container.querySelector('[data-testid="notification-abcde-close-btn"]');
      expect(rendered.container).not.toContainElement(closeButton);
    });
  });
});

const renderComponent = (additionalProps = {}) => {
  const fixedProps = { notifications: notifications };
  const props = { ...fixedProps, ...additionalProps };

  return render(<ActionNotifications {...props} />);
};
