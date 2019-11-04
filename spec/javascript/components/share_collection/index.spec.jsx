import { cleanup, fireEvent, render, wait, waitForElement, waitForElementToBeRemoved } from "@testing-library/react";
import ActionNotifications from "components/action_notifications";
import axios from "axios";
import React from "react";
import ShareCollection from "components/share_collection/share_collection";

jest.mock("axios");

let collection;
let data;
const i18nPrefix = "components.share_collection";

beforeEach(() => {
  collection = {
    id: "abcdefg",
    name: "Mongolia - Summer 2019"
  };

  data = {
    via_link: {
      enabled: true,
      url: "www.example.co/after"
    }
  };
});

afterEach(cleanup);
afterEach(() => { jest.clearAllMocks(); });

describe("<ShareCollection />", () => {

  describe("before initial data fetch", () => {
    it("renders the component with loading state", () => {
      // Use the long form of mocking implementation so we can
      // assert the loading state is enabled
      axios.get.mockImplementation(async () => {
        await expect(rendered.container.querySelector(".share-collection__loading-icon")).not.toBeNull();
        Promise.resolve({ data: data });
      });

      const rendered = renderComponent();
    });
  });

  describe("after initial data fetch", () => {
    beforeEach(() => {
      axios.get.mockResolvedValue({ data: data });
    });

    it("renders the component when link sharing is enabled", async () => {
      data.via_link.enabled = true;

      const rendered = renderComponent();

      const toggleContainer = await waitForElement(
        () => rendered.getByTestId("link-sharing-toggle"),
        { container: rendered.container }
      );

      const toggleSwitch = toggleContainer.querySelector(".switch");
      const linkSharingContent = rendered.queryByTestId("link-sharing-content");
      const loadingIcon = rendered.container.querySelector(".share-collection__loading-icon");

      expect(toggleSwitch).toHaveClass("on");
      expect(linkSharingContent).not.toBeNull();

      expect(axios.get).toHaveBeenCalledTimes(1);
      expect(loadingIcon).toBeNull();
    });

    it("renders the component when link sharing is disabled", async () => {
      data.via_link.enabled = false;

      const rendered = renderComponent();

      const toggleContainer = await waitForElement(
        () => rendered.getByTestId("link-sharing-toggle"),
        { container: rendered.container }
      );

      const toggleSwitch = toggleContainer.querySelector(".switch");
      const linkSharingContent = rendered.queryByTestId("link-sharing-content");
      const loadingIcon = rendered.container.querySelector(".share-collection__loading-icon");

      expect(toggleSwitch).not.toHaveClass("on");
      expect(linkSharingContent).toBeNull();

      expect(axios.get).toHaveBeenCalledTimes(1);
      expect(loadingIcon).toBeNull();
    });
  });

  describe("data fetch fails", () => {
    beforeEach(() => {
      axios.get.mockRejectedValue({ error: "some error" });
    });

    it("displays the <ModalError /> component", async () => {
      const rendered = renderComponent();

      const modalError = await waitForElement(
        () => rendered.container.querySelector(".modal--error"),
        { container: rendered.container }
      );

      expect(modalError).toHaveTextContent(I18n.t("generic_error"));
    });
  });


  it("user can toggle link sharing", async () => {
    // Initial fetch - start off with link sharing DISABLED
    data.via_link.enabled = false;
    axios.get.mockResolvedValue({ data: data });

    //
    // Render, expect link sharing to be DISABLED
    //

    const rendered = renderComponent();

    let toggleContainer = await waitForElement(
      () => rendered.getByTestId("link-sharing-toggle"),
      { container: rendered.container }
    );

    let toggleSwitch = toggleContainer.querySelector(".switch");
    let linkSharingContent = rendered.queryByTestId("link-sharing-content");
    expect(toggleSwitch).not.toHaveClass("on");
    expect(linkSharingContent).toBeNull();

    //
    // Click switch, expect link sharing to be ENABLED
    //

    data.via_link.enabled = true;
    axios.patch.mockResolvedValue({ data: data });

    fireEvent.click(toggleSwitch);

    linkSharingContent = await waitForElement(
      () => rendered.queryByTestId("link-sharing-content"),
      { container: rendered.container }
    );

    expect(toggleSwitch).toHaveClass("on");
    expect(axios.patch).toHaveBeenCalledTimes(1);

    //
    // Click switch, expect link sharing to be DISABLED
    //

    data.via_link.enabled = false;
    axios.patch.mockResolvedValue({ data: data });

    fireEvent.click(toggleSwitch);

    linkSharingContent = await waitForElementToBeRemoved(
      () => rendered.getByTestId("link-sharing-content"),
      { container: rendered.container }
    );

    expect(toggleSwitch).not.toHaveClass("on");
    expect(axios.patch).toHaveBeenCalledTimes(2);

  });

  describe("copying link", () => {
    let rendered;

    beforeEach(async () => {
      // Mock document.* calls
      const queryFunc = jest.fn(() => { return { focus: jest.fn(), select: jest.fn() }; });
      const execFunc = jest.fn();
      Object.defineProperty(document, "querySelector", { value: queryFunc, configurable: true });
      Object.defineProperty(document, "execCommand", { value: execFunc, configurable: true });

      data.via_link.enabled = true;
      axios.get.mockResolvedValue({ data: data });

      rendered = renderComponent();

      await waitForElement(
        () => rendered.getByTestId("link-sharing-toggle"),
        { container: rendered.container }
      );
    });

    afterEach(() => {
      delete document.querySelector;
      delete document.execCommand;
    });

    it("user can copy link", () => {
      let button = rendered.getByTestId("copy-link");

      const actionNotifications = render(<ActionNotifications notifications={[]} />).container;

      fireEvent.click(button);

      expect(actionNotifications.querySelector(".notification--success")).not.toBeNull();
      expect(actionNotifications).toHaveTextContent(I18n.t(i18nPrefix + ".copy_link.success"));
    });
  });

  describe("user can renew link", () => {
    let rendered;

    beforeEach(async () => {
      data.via_link.enabled = true;
      axios.get.mockResolvedValue({ data: data });

      rendered = renderComponent();

      await waitForElement(
        () => rendered.getByTestId("link-sharing-toggle"),
        { container: rendered.container }
      );
    });

    it("user can renew link", async () => {
      let input = rendered.getByTestId("url-input");
      expect(input).toHaveAttribute("value", data.via_link.url);

      data.via_link.url = "www.example.com/something-new";
      axios.post.mockResolvedValue({ data: data });

      let button = rendered.getByTestId("renew-link");
      fireEvent.click(button);

      input = rendered.getByTestId("url-input");
      await wait(
        () => expect(input).toHaveAttribute("value", data.via_link.url)
      );
    });
  });
});

const renderComponent = (additionalProps = {}) => {
  const fixedProps = { collection: collection };
  const props = {...fixedProps, ...additionalProps };

  return render(<ShareCollection {...props} />);
};
