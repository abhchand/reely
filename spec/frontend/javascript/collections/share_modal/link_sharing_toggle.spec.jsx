import { cleanup, fireEvent, render } from '@testing-library/react';
import { stripHtmlTags } from 'test_utils/utils';
import ActionNotifications from 'components/action_notifications';
import axios from 'axios';
import LinkSharingToggle from 'collections/share_modal/link_sharing_toggle';
import React from 'react';

jest.mock('axios');

let collection;
let setCollection;
let actionNotifications;
const i18nPrefix = 'collections.share_modal.link_sharing_toggle';

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

describe('<LinkSharingToggle />', () => {
  it('renders the component when link sharing is enabled', () => {
    collection.sharing_config.via_link.enabled = true;

    const rendered = renderComponent();

    const toggleContainer = rendered.getByTestId('link-sharing-toggle');
    const toggleSwitch = toggleContainer.querySelector('.switch');
    const content = toggleContainer.querySelector('span');

    expect(toggleSwitch).toHaveClass('on');
    expect(content).toHaveTextContent(stripHtmlTags(I18n.t(`${i18nPrefix}.enabled`)));
  });

  it('renders the component when link sharing is disabled', () => {
    collection.sharing_config.via_link.enabled = false;

    const rendered = renderComponent();

    const toggleContainer = rendered.getByTestId('link-sharing-toggle');
    const toggleSwitch = toggleContainer.querySelector('.switch');
    const content = toggleContainer.querySelector('span');

    expect(toggleSwitch).not.toHaveClass('on');
    expect(content).toHaveTextContent(stripHtmlTags(I18n.t(`${i18nPrefix}.disabled`)));
  });

  describe('button onClick event', () => {
    let data;
    let rendered;
    let toggleContainer;
    let toggleSwitch;

    beforeEach(() => {
      data = { via_link: { enabled: false, url: 'www.example.co/after' } };

      // Explicitly ensure we are always testing toggling from false -> true
      collection.sharing_config.via_link.enabled = false;

      rendered = renderComponent();
      toggleContainer = rendered.getByTestId('link-sharing-toggle');
      toggleSwitch = toggleContainer.querySelector('.switch');
    });

    it('does not update toggle while fetching', () => {

      /*
       * Use the long form of mocking implementation so we can
       * assert the loading state is enabled
       */
      axios.patch.mockImplementation(async() => {
        await expect(toggleSwitch).not.toHaveClass('on');
        expect(toggleContainer.querySelector('span')).toHaveTextContent(stripHtmlTags(I18n.t(`${i18nPrefix}.disabled`)));

        Promise.resolve({ data: data });
      });

      fireEvent.click(toggleSwitch);
    });

    describe('on success', () => {
      beforeEach(() => {
        axios.patch.mockResolvedValue({ data: data });
      });

      it('no longer displays the loading state', async() => {
        fireEvent.click(toggleSwitch);

        await expect(toggleSwitch).not.toHaveAttribute('disabled', 'disabled');
      });

      it('calls the setCollection() handler with the updated collection', async() => {
        fireEvent.click(toggleSwitch);

        await expect(axios.patch).toHaveBeenCalledTimes(1);
        await expect(setCollection).toHaveBeenCalled();

        const newCollection = collection;
        newCollection.sharing_config.via_link.enabled = true;

        expect(setCollection.mock.calls[0][0]).toBe(newCollection);
      });
    });

    describe('on fail', () => {
      beforeEach(() => {
        axios.patch.mockRejectedValue('Some error');
      });

      it('no longer displays the loading state', async() => {
        fireEvent.click(toggleSwitch);

        await expect(toggleSwitch).not.toHaveAttribute('disabled', 'disabled');
      });

      it('does not call the setCollection() handler', async() => {
        fireEvent.click(toggleSwitch);

        await expect(axios.patch).toHaveBeenCalledTimes(1);
        await expect(setCollection).not.toHaveBeenCalled();
      });

      it('displays the action notification', async() => {
        fireEvent.click(toggleSwitch);

        /*
         * <hack>
         * It seems awaiting these two expectations is necessary in order to
         * give the action notifications time to load. If these are removed
         * the action notification expectation fails -_-
         */
        await expect(axios.patch).toHaveBeenCalledTimes(1);
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

  return render(<LinkSharingToggle {...props} />);
};
