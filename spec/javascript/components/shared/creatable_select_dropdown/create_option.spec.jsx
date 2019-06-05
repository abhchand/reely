import { cleanup, fireEvent, render } from "react-testing-library";
import CreateOption from "components/shared/creatable_select_dropdown/create_option";
import KeyCodes from "test_utils/key_codes";
import React from "react";

let searchInputValue;
let onClick;

const defaults = CreateOption.defaultProps;

beforeEach(() => {
  onClick = jest.fn();
  searchInputValue = "Georgia";
});

afterEach(cleanup);

describe("<CreateOption />", () => {
  it("renders the component", () => {
    const rendered = renderComponent();

    const button = rendered.getByTestId("create-option");
    expect(button).toHaveAttribute("role", "button");

    const content = button.querySelector("span");
    expect(content).toHaveTextContent(defaults.labelGenerator(searchInputValue));
  });

  describe("searchInputValue is an empty string", () => {
    it("renders a null component", () => {
      const rendered = renderComponent({ searchInputValue: "" });

      const button = rendered.queryByTestId("create-option");
      expect(rendered.container).not.toContainElement(button);
    });
  });

  describe("button click event", () => {
    it("it fires onClick", () => {
      const rendered = renderComponent();

      const button = rendered.getByTestId("create-option");
      fireEvent.click(button);

      expect(onClick).toHaveBeenCalled();
    });
  });

  describe("button keyDown event", () => {
    it("fires onClick if Enter was pressed", () => {
      const rendered = renderComponent();

      const button = rendered.getByTestId("create-option");
      fireEvent.keyDown(button, KeyCodes.ENTER);

      expect(onClick).toHaveBeenCalled();
    });

    it("does not fire onClick if another key was pressed", () => {
      const rendered = renderComponent();

      const button = rendered.getByTestId("create-option");
      fireEvent.keyDown(button, KeyCodes.ESCAPE);

      expect(onClick).not.toHaveBeenCalled();
    });
  });

  describe("labelGenerator prop", () => {
    it("overrides the default labelGenerator when present", () => {
      const labelGenerator = (text) => (`${text} - foo`);
      const rendered = renderComponent({labelGenerator: labelGenerator });

      const button = rendered.getByTestId("create-option");
      const content = button.querySelector("span");

      expect(content).toHaveTextContent(`${searchInputValue} - foo`);
    });
  });
});

const renderComponent = (additionalProps = {}) => {
  const fixedProps = { searchInputValue: searchInputValue, onClick: onClick };
  const props = {...fixedProps, ...additionalProps };

  return render(<CreateOption {...props} />);
};

