import { cleanup, fireEvent, render } from '@testing-library/react';
import ActionNotifications from 'javascript/components/action_notifications';
import axios from 'axios';
import React from 'react';
import RenewLink from 'collections/share_modal/renew_link';

jest.mock('axios');

let collection;
let setCollection;
let actionNotifications;
const i18nPrefix = 'collections.share_modal.renew_link';

beforeEach(() => {
  collection = {
    id: 'abcdefg',
    name: 'Mongolia - Summer 2019',
    sharing_config: {
      via_link: {
        enabled: false,
        url: 'https://www.example.com/before'
      }
    }
  };

  setCollection = jest.fn();
  actionNotifications = render(<ActionNotifications notifications={[]} />);
});

afterEach(cleanup);
afterEach(() => { jest.clearAllMocks(); });

describe('<RenewLink />', () => {
  it('renders the component', () => {
    const rendered = renderComponent();

    const link = rendered.getByTestId('renew-link');

    const loading = rendered.container.querySelector('loading');
    expect(loading).toBeNull();

    expect(link).toHaveTextContent(I18n.t(`${i18nPrefix}.label`));
  });

  it('does not render the loading state', () => {
    const rendered = renderComponent();
    const link = rendered.getByTestId('renew-link');

    const loading = link.querySelector('loading');
    expect(loading).toBeNull();
  });

  describe('link onClick event', () => {
    let data;

    beforeEach(() => {
      data = { via_link: { enabled: true, url: 'www.example.co/after' } };
    });

    it('displays the loading state while fetching', () => {

      /*
       * Use the long form of mocking implementation so we can
       * assert the loading state is enabled
       */
      axios.post.mockImplementation(async() => {
        await expect(link.querySelector('loading')).not.toBeNull();
        expect(link).toHaveTextContent(I18n.t(`${i18nPrefix}.loading`));

        Promise.resolve({ data: data });
      });

      const rendered = renderComponent();

      const link = rendered.getByTestId('renew-link');
      fireEvent.click(link);
    });

    it('disables the link during the loading state', () => {

      /*
       * Use the long form of mocking implementation so we can
       * assert the loading state is enabled
       */
      axios.post.mockImplementation(async() => {
        await expect(link.querySelector('loading')).not.toBeNull();

        // Click again while loading state is active
        fireEvent.click(link);
        await expect(axios.post).not.toHaveBeenCalled();

        Promise.resolve({ data: data });
      });

      const rendered = renderComponent();

      const link = rendered.getByTestId('renew-link');
      fireEvent.click(link);
    });

    describe('on success', () => {
      let rendered;
      let link;

      beforeEach(() => {
        axios.post.mockResolvedValue({ data: data });

        rendered = renderComponent();
        link = rendered.getByTestId('renew-link');
      });

      it('no longer displays the loading state', async() => {
        fireEvent.click(link);

        await expect(link.querySelector('loading')).toBeNull();
      });

      it('calls the setCollection() handler', async() => {
        fireEvent.click(link);

        await expect(axios.post).toHaveBeenCalledTimes(1);
        await expect(setCollection).toHaveBeenCalled();
      });
    });

    describe('on fail', () => {
      let rendered;
      let link;

      beforeEach(() => {
        axios.post.mockRejectedValue('Some error');

        rendered = renderComponent();
        link = rendered.getByTestId('renew-link');
      });

      it('no longer displays the loading state', async() => {
        fireEvent.click(link);

        await expect(link.querySelector('loading')).toBeNull();
      });

      it('does not call the setCollection() handler', async() => {
        fireEvent.click(link);

        await expect(axios.post).toHaveBeenCalledTimes(1);
        await expect(setCollection).not.toHaveBeenCalled();
      });

      it('displays the action notification', async() => {
        fireEvent.click(link);

        /*
         * <hack>
         * It seems awaiting these two expectations is necessary in order to
         * give the action notifications time to load. If these are removed
         * the action notification expectation fails -_-
         */
        await expect(axios.post).toHaveBeenCalledTimes(1);
        await expect(setCollection).not.toHaveBeenCalled();
        // </hack>

        await expect(actionNotifications.container.querySelector('.notification--error')).not.toBeNull();
        expect(actionNotifications.container).toHaveTextContent(I18n.t(`${i18nPrefix}.failure`));
      });
    });
  });
});

const renderComponent = (additionalProps = {}) => {
  const fixedProps = { collection: collection, setCollection: setCollection };
  const props = { ...fixedProps, ...additionalProps };

  return render(<RenewLink {...props} />);
};
