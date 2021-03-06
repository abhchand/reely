import { cleanup, fireEvent, render } from '@testing-library/react';
import ActionNotifications from 'javascript/components/action_notifications';
import CopyLink from 'collections/share_modal/copy_link';
import React from 'react';

const i18nPrefix = 'collections.share_modal.copy_link';

beforeEach(() => {
  // Mock document.* calls
  const queryFunc = jest.fn(() => {
    return { focus: jest.fn(), select: jest.fn() };
  });
  const execFunc = jest.fn();
  Object.defineProperty(document, 'querySelector', {
    value: queryFunc,
    configurable: true
  });
  Object.defineProperty(document, 'execCommand', {
    value: execFunc,
    configurable: true
  });
});

afterEach(cleanup);

afterEach(() => {
  delete document.querySelector;
  delete document.execCommand;
});

describe('<CopyLink />', () => {
  it('renders the component', () => {
    const rendered = renderComponent();

    const button = rendered.getByTestId('copy-link');
    expect(button).toHaveAttribute('type', 'button');

    const icon = button.querySelector('svg');
    expect(icon).not.toBeNull();
  });

  describe('button onClick event', () => {
    let rendered;
    let button;

    beforeEach(() => {
      rendered = renderComponent();
      button = rendered.getByTestId('copy-link');
    });

    describe('on success', () => {
      it('displays the action notification', () => {
        const actionNotifications = render(
          <ActionNotifications notifications={[]} />
        ).container;

        fireEvent.click(button);

        expect(
          actionNotifications.querySelector('.notification--success')
        ).not.toBeNull();
        expect(actionNotifications).toHaveTextContent(
          I18n.t(`${i18nPrefix}.success`)
        );
      });
    });

    describe('on fail', () => {
      beforeEach(() => {
        delete document.execCommand;
        Object.defineProperty(document, 'execCommand', {
          value: jest.fn().mockImplementation(() => {
            throw new Error();
          }),
          configurable: true
        });
      });

      it('displays the action notification', () => {
        const actionNotifications = render(
          <ActionNotifications notifications={[]} />
        ).container;

        fireEvent.click(button);

        expect(
          actionNotifications.querySelector('.notification--success')
        ).toBeNull();
      });
    });
  });
});

const renderComponent = (additionalProps = {}) => {
  const fixedProps = {};
  const props = { ...fixedProps, ...additionalProps };

  return render(<CopyLink {...props} />);
};
