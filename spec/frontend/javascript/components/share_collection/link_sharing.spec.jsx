import { cleanup, render } from '@testing-library/react';
import LinkSharing from 'components/share_collection/link_sharing';
import React from 'react';

let collection;
let setCollection;
// eslint-disable-next-line no-unused-vars
const i18nPrefix = 'components.share_collection.link_sharing';

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
});

afterEach(cleanup);
afterEach(() => { jest.clearAllMocks(); });

describe('<LinkSharing />', () => {
  it('renders the component when link sharing is enabled', () => {
    collection.sharing_config.via_link.enabled = true;

    const rendered = renderComponent();

    const linkSharingContainer = rendered.getByTestId('link-sharing');
    const toggleContainer = rendered.getByTestId('link-sharing-toggle');
    const toggleSwitch = toggleContainer.querySelector('.switch');
    const urlInput = rendered.getByTestId('url-input');
    const copyLinkButton = rendered.getByTestId('copy-link');
    const renewLinkButton = rendered.getByTestId('renew-link');

    expect(linkSharingContainer).not.toBeNull();
    expect(toggleContainer).not.toBeNull();
    expect(toggleSwitch).toHaveClass('on');
    expect(urlInput).not.toBeNull();
    expect(copyLinkButton).not.toBeNull();
    expect(renewLinkButton).not.toBeNull();
  });

  it('renders the component when link sharing is disabled', () => {
    collection.sharing_config.via_link.enabled = false;

    const rendered = renderComponent();

    const linkSharingContainer = rendered.getByTestId('link-sharing');
    const toggleContainer = rendered.getByTestId('link-sharing-toggle');
    const toggleSwitch = toggleContainer.querySelector('.switch');
    const urlInput = rendered.queryByTestId('url-input');
    const copyLinkButton = rendered.queryByTestId('copy-link');
    const renewLinkButton = rendered.queryByTestId('renew-link');

    expect(linkSharingContainer).not.toBeNull();
    expect(toggleContainer).not.toBeNull();
    expect(toggleSwitch).not.toHaveClass('on');
    expect(urlInput).toBeNull();
    expect(copyLinkButton).toBeNull();
    expect(renewLinkButton).toBeNull();
  });
});

const renderComponent = (additionalProps = {}) => {
  const fixedProps = { collection: collection, setCollection: setCollection };
  const props = { ...fixedProps, ...additionalProps };

  return render(<LinkSharing {...props} />);
};
