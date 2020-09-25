import { cleanup, render } from '@testing-library/react';
import React from 'react';
import Url from 'collections/share_modal/url';

let collection;

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
});

afterEach(cleanup);

describe('<Url />', () => {
  it('renders the component', () => {
    const rendered = renderComponent();

    const input = rendered.getByTestId('url-input');

    expect(input).not.toBeNull();
    expect(input).toHaveAttribute(
      'value',
      collection.sharing_config.via_link.url
    );
    expect(input).toHaveAttribute('readOnly', '');
  });
});

const renderComponent = (additionalProps = {}) => {
  const fixedProps = { collection: collection };
  const props = { ...fixedProps, ...additionalProps };

  return render(<Url {...props} />);
};
