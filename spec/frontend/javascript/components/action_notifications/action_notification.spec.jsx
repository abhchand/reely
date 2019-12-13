import { cleanup, fireEvent, render } from '@testing-library/react';
import ActionNotification from 'components/action_notifications/action_notification';
import React from 'react';

let onClose;
let notification;

const defaultDuration = ActionNotification.defaultProps.duration;
const defaultCloseButtonLabel = ActionNotification.defaultProps.closeButtonLabel;

beforeEach(() => {
  jest.useFakeTimers();

  onClose = jest.fn();
  notification = { id: 'abcde', content: <div className="content">content</div>, type: 'error' };
});

afterEach(cleanup);

describe('<ActionNotification />', () => {
  it('renders the component', () => {
    const rendered = renderComponent();

    const actionNotification = rendered.getByTestId('notification-abcde');
    expect(actionNotification).toHaveClass('notification--error');

    const content = rendered.container.querySelector('.content');
    expect(content).toHaveTextContent('content');

    const closeButton = rendered.getByTestId('notification-abcde-close-btn');
    expect(closeButton).toHaveTextContent(defaultCloseButtonLabel);
  });

  it('closes after the duration expires', () => {
    renderComponent();

    // 0.0 secs
    expect(onClose).not.toBeCalled();

    // <defaultDuration> secs
    jest.advanceTimersByTime(defaultDuration);
    expect(onClose).toBeCalled();
    expect(onClose).toHaveBeenCalledTimes(1);
  });

  /* eslint-disable no-magic-numbers */
  it('persists on mouse hover', () => {
    const now = Date.now();
    mockDateOnceAs(now);

    const rendered = renderComponent({ duration: 1000 });
    const actionNotification = rendered.getByTestId('notification-abcde');

    // 0.0 secs
    expect(onClose).not.toBeCalled();

    // 0.4 secs
    mockDateOnceAs(now + 400);
    jest.advanceTimersByTime(400);
    fireEvent.mouseEnter(actionNotification);
    expect(onClose).not.toBeCalled();

    // 0.6 secs
    mockDateOnceAs(now + 200);
    jest.advanceTimersByTime(200);
    fireEvent.mouseLeave(actionNotification);
    expect(onClose).not.toBeCalled();

    /*
     * 1.0 secs
     * Mouse hover lasted 0.2 seconds, which doesn'tt contribute
     * towards the total persisted duration. So notification should
     * not yet be closed.
     */
    mockDateOnceAs(now + 400);
    jest.advanceTimersByTime(400);
    expect(onClose).not.toBeCalled();

    // 1.2 secs
    mockDateOnceAs(now + 200);
    jest.advanceTimersByTime(200);
    expect(onClose).toBeCalled();
    expect(onClose).toHaveBeenCalledTimes(1);
  });
  /* eslint-enable no-magic-numbers */

  describe('notification type', () => {
    it('defaults to success if notification type is null', () => {
      notification.type = null;

      const rendered = renderComponent();

      const actionNotification = rendered.getByTestId('notification-abcde');
      expect(actionNotification).toHaveClass('notification--success');
    });

    it('defaults to success if notification type is invalid', () => {
      notification.type = 'foo';

      const rendered = renderComponent();

      const actionNotification = rendered.getByTestId('notification-abcde');
      expect(actionNotification).toHaveClass('notification--success');
    });
  });

  describe('content', () => {
    it('wraps the content in <span> tags if content is a plaintext string', () => {
      notification.content = 'content';

      const rendered = renderComponent();

      const content = rendered.container.querySelector('span');
      expect(content).toHaveTextContent('content');
    });
  });

  describe('isDismissable prop', () => {
    it('renders a close button when set to true', () => {
      const rendered = renderComponent({ isDismissable: true });

      const closeButton = rendered.getByTestId('notification-abcde-close-btn');
      expect(closeButton).toHaveTextContent(defaultCloseButtonLabel);
    });

    it('does not render a close button when set to false', () => {
      const rendered = renderComponent({ isDismissable: false });

      const closeButton = rendered.queryByTestId('notification-abcde-close-btn');
      expect(closeButton).toBeNull();
    });

    it('allows the notification to be dismissed on click', () => {
      const rendered = renderComponent();
      const closeButton = rendered.getByTestId('notification-abcde-close-btn');

      // 0.0 secs
      expect(onClose).not.toBeCalled();

      // <0.5 * defaultDuration> secs
      // eslint-disable-next-line no-magic-numbers
      jest.advanceTimersByTime(defaultDuration / 2);
      fireEvent.click(closeButton);
      expect(onClose).toBeCalled();
      expect(onClose).toHaveBeenCalledTimes(1);
    });


    describe('closeButtonLabel prop', () => {
      it('overrides the default close button label when present', () => {
        const rendered = renderComponent({ closeButtonLabel: 'Foo' });

        const closeButton = rendered.getByTestId('notification-abcde-close-btn');
        expect(closeButton).toHaveTextContent('Foo');
      });
    });
  });

  describe('duration prop', () => {
    it('overrides the default duration when present', () => {
      // eslint-disable-next-line no-magic-numbers
      renderComponent({ duration: defaultDuration + 1000 });

      // 0.0 secs
      expect(onClose).not.toBeCalled();

      // <defaultDuration> secs
      jest.advanceTimersByTime(defaultDuration);
      expect(onClose).not.toBeCalled();

      // <defaultDuration + 1.0> secs
      // eslint-disable-next-line no-magic-numbers
      jest.advanceTimersByTime(1000);
      expect(onClose).toBeCalled();
      expect(onClose).toHaveBeenCalledTimes(1);
    });
  });
});

const mockDateOnceAs = (unixTime) => {
  jest.spyOn(global.Date, 'now').mockImplementation(() => new Date(unixTime).valueOf());
};

const renderComponent = (additionalProps = {}) => {
  const fixedProps = { notification: notification, onClose: onClose };
  const props = { ...fixedProps, ...additionalProps };

  return render(<ActionNotification {...props} />);
};
