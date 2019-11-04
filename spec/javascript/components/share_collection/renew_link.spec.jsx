import { cleanup, fireEvent, render } from "react-testing-library";
import ActionNotifications from "components/action_notifications";
import axios from "axios";
import React from "react";
import RenewLink from "components/share_collection/renew_link";

jest.mock("axios");

let collection;
let setCollection;
const i18nPrefix = "components.share_collection.renew_link";

beforeEach(() => {
  collection = {
    id: "abcdefg",
    name: "Mongolia - Summer 2019",
    sharing_config: {
      via_link: {
        enabled: false,
        url: "https://www.example.com/before"
      }
    }
  };

  setCollection = jest.fn();
});

afterEach(cleanup);
afterEach(() => { jest.clearAllMocks(); });

describe("<RenewLink />", () => {
  it("renders the component", () => {
    const rendered = renderComponent();

    const button = rendered.getByTestId("renew-link");
    expect(button).toHaveAttribute("type", "button");

    const loading = button.querySelector("loading");
    expect(loading).toBeNull();

    const icon = button.querySelector("svg");
    expect(icon).not.toBeNull();

    const content = button.querySelector("span");
    expect(content).toHaveTextContent(I18n.t(i18nPrefix + ".label"));
  });

  it("does not render the loading state", () => {
    const rendered = renderComponent();
    const button = rendered.getByTestId("renew-link");

    const loading = button.querySelector("loading");
    expect(loading).toBeNull();
  });

  describe("button onClick event", () => {
    let data;

    beforeEach(() => {
      data = { via_link: { enabled: true, url: "www.example.co/after" } };
    });

    it("displays the loading state while fetching", () => {
      // Use the long form of mocking implementation so we can
      // assert the loading state is enabled
      axios.post.mockImplementation(async () => {
        await expect(button.querySelector("loading")).not.toBeNull();
        expect(button).toHaveTextContent(I18n.t(i18nPrefix + ".loading"));

        Promise.resolve({ data: data });
      });

      const rendered = renderComponent();

      const button = rendered.getByTestId("renew-link");
      fireEvent.click(button);
    });

    it("disables the button during the loading state", () => {
      // Use the long form of mocking implementation so we can
      // assert the loading state is enabled
      axios.post.mockImplementation(async () => {
        await expect(button.querySelector("loading")).not.toBeNull();

        // Click again while loading state is active
        fireEvent.click(button);
        await expect(axios.post).not.toHaveBeenCalled();

        Promise.resolve({ data: data });
      });

      const rendered = renderComponent();

      const button = rendered.getByTestId("renew-link");
      fireEvent.click(button);
    });

    describe("on success", () => {
      let rendered;
      let button;

      beforeEach(() => {
        axios.post.mockResolvedValue({ data: data });

        rendered = renderComponent();
        button = rendered.getByTestId("renew-link");
      });

      it("no longer displays the loading state", async () => {
        fireEvent.click(button);

        await expect(button.querySelector("loading")).toBeNull();
      });

      it("calls the setCollection() handler", async () => {
        fireEvent.click(button);

        await expect(axios.post).toHaveBeenCalledTimes(1);
        await expect(setCollection).toHaveBeenCalled();
      });
    });

    describe("on fail", () => {
      let rendered;
      let button;

      beforeEach(() => {
        axios.post.mockRejectedValue("Some error");

        rendered = renderComponent();
        button = rendered.getByTestId("renew-link");
      });

      it("no longer displays the loading state", async () => {
        fireEvent.click(button);

        await expect(button.querySelector("loading")).toBeNull();
      });

      it("does not call the setCollection() handler", async () => {
        fireEvent.click(button);

        await expect(axios.post).toHaveBeenCalledTimes(1);
        await expect(setCollection).not.toHaveBeenCalled();
      });

      it("displays the action notification", async () => {
        const actionNotifications = render(<ActionNotifications notifications={[]} />).container;

        fireEvent.click(button);

        // <hack>
        // It seems awaiting these two expectations is necessary in order to
        // give the action notifications time to load. If these are removed
        // the action notification expectation fails -_-
        await expect(axios.post).toHaveBeenCalledTimes(1);
        await expect(setCollection).not.toHaveBeenCalled();
        // </hack>

        await expect(actionNotifications.querySelector(".notification--error")).not.toBeNull();
        expect(actionNotifications).toHaveTextContent(I18n.t(i18nPrefix + ".failure"));
      });
    });
  });
});

const renderComponent = (additionalProps = {}) => {
  const fixedProps = { collection: collection, setCollection: setCollection };
  const props = {...fixedProps, ...additionalProps };

  return render(<RenewLink {...props} />);
};
