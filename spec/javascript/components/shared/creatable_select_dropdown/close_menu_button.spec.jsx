import { cleanup, fireEvent, render } from "react-testing-library";
import CloseMenuButton from "components/shared/creatable_select_dropdown/close_menu_button";
import KeyCodes from "test_utils/key_codes";
import React from "react";

let onClick;

const defaults = CloseMenuButton.defaultProps;

beforeEach(() => {
  onClick = jest.fn();
});

afterEach(cleanup);

describe("<CloseMenuButton />", () => {
  it("renders the component", () => {
    const rendered = renderComponent();

    const button = rendered.getByTestId("close-menu-button");
    expect(button).toHaveAttribute("role", "button");

    const content = button.querySelector("span");
    expect(content).toHaveTextContent(defaults.label);
  });

  describe("label prop", () => {
    it("overrides the default label when present", () => {
      const rendered = renderComponent({ label: "foo" });

      const button = rendered.getByTestId("close-menu-button");

      const content = button.querySelector("span");
      expect(content).toHaveTextContent("foo");
    });
  });

  describe("button click event", () => {
    it("fires onClick", () => {
      const rendered = renderComponent();

      const button = rendered.getByTestId("close-menu-button");
      fireEvent.click(button);

      expect(onClick).toHaveBeenCalled();
    });
  });

  describe("button keyPress event", () => {
    it("fires onClick if Enter was pressed", () => {
      const rendered = renderComponent();

      const button = rendered.getByTestId("close-menu-button");
      fireEvent.keyPress(button, KeyCodes.ENTER);

      expect(onClick).toHaveBeenCalled();
    });

    it("does not fire onClick if another key was pressed", () => {
      const rendered = renderComponent();

      const button = rendered.getByTestId("close-menu-button");
      fireEvent.keyPress(button, KeyCodes.ESCAPE);

      expect(onClick).not.toHaveBeenCalled();
    });
  });
});

const renderComponent = (additionalProps = {}) => {
  const fixedProps = { onClick: onClick };
  const props = {...fixedProps, ...additionalProps };

  return render(<CloseMenuButton {...props} />);
};
