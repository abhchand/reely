import { cleanup, fireEvent, render } from "react-testing-library";
import KeyCodes from "test_utils/key_codes";
import OpenMenuButton from "components/shared/creatable_select_dropdown/open_menu_button";
import React from "react";

let onClick;

beforeEach(() => {
  onClick = jest.fn();
});

afterEach(cleanup);

describe("<OpenMenuButton />", () => {
  it("renders the component", () => {
    const rendered = renderComponent();

    const button = rendered.getByTestId("open-menu-button");
    expect(button).toHaveAttribute("role", "button");
  });

  describe("button click event", () => {
    it("fires onClick", () => {
      const rendered = renderComponent();

      const button = rendered.getByTestId("open-menu-button");
      fireEvent.click(button);

      expect(onClick).toHaveBeenCalled();
    });
  });

  describe("button keyPress event", () => {
    it("fires onClick if Enter was pressed", () => {
      const rendered = renderComponent();

      const button = rendered.getByTestId("open-menu-button");
      fireEvent.keyPress(button, KeyCodes.ENTER);

      expect(onClick).toHaveBeenCalled();
    });

    it("does not fire onClick if another key was pressed", () => {
      const rendered = renderComponent();

      const button = rendered.getByTestId("open-menu-button");
      fireEvent.keyPress(button, KeyCodes.ESCAPE);

      expect(onClick).not.toHaveBeenCalled();
    });
  });
});

const renderComponent = (additionalProps = {}) => {
  const fixedProps = { onClick: onClick };
  const props = {...fixedProps, ...additionalProps };

  return render(<OpenMenuButton {...props} />);
};
