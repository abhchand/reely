import { cleanup, fireEvent, render } from "react-testing-library";
import KeyCodes from "test_utils/key_codes";
import React from "react";
import SelectOptions from "components/shared/creatable_select_dropdown/select_options";

let rendered;

let options;
let currentSelectedOptionIndex;
let onClick;

const defaults = SelectOptions.defaultProps;

beforeEach(() => {
  options = [
    { id: "TN", name: "Tamil Nadu" },
    { id: "MH", name: "Maharashtra" },
    { id: "KL", name: "Kerala" }
  ];

  currentSelectedOptionIndex = 0;
  onClick = jest.fn();
});

afterEach(cleanup);

describe("<SelectOptions />", () => {
  it("renders the component with the correct selected option", () => {
    rendered = renderComponent({ currentSelectedOptionIndex: 1 });

    expect(displayedOptions()).toMatchObject(options);

    const selected = getElementSelectOptions().querySelector("li.selected");
    expect(selected.dataset.id).toBe("MH");
  });

  describe("no options exist", () => {
    it("renders the empty state", () => {
      rendered = renderComponent({ options: [] });

      expect(displayedOptions()).toMatchObject([]);
      expect(getElementSelectOptions()).toHaveTextContent(defaults.textForEmptyState);
    });
  });

  describe("textForEmptyState prop", () => {
    it("overrides the default textForEmptyState when present", () => {
      rendered = renderComponent({ options: [], textForEmptyState: "foo" });

      expect(getElementSelectOptions()).toHaveTextContent("foo");
    });
  });

  describe("option onClick event", () => {
    it("fires onClick event", () => {
      rendered = renderComponent();
      expect(onClick).not.toHaveBeenCalled();

      fireEvent.click(getOption("KL").querySelector("div"));

      expect(onClick).toHaveBeenCalled();
      expect(onClick.mock.calls[0]).toMatchObject(["KL"]);
    });
  });

  describe("option keyDown event", () => {
    it("fires onClick if Enter was pressed", () => {
      rendered = renderComponent();
      expect(onClick).not.toHaveBeenCalled();

      fireEvent.keyDown(getOption("KL").querySelector("div"), KeyCodes.ENTER);

      expect(onClick).toHaveBeenCalled();
      expect(onClick.mock.calls[0]).toMatchObject(["KL"]);
    });

    it("does not fire onClick if another key was pressed", () => {
      rendered = renderComponent();
      expect(onClick).not.toHaveBeenCalled();

      fireEvent.keyDown(getOption("KL").querySelector("div"), KeyCodes.ESCAPE);

      expect(onClick).not.toHaveBeenCalled();
    });
  });
});

const getElementSelectOptions = () => (rendered.getByTestId("select-options"));

const getOption = (optionId) => (getElementSelectOptions().querySelector(`li[data-id="${optionId}"]`));

const displayedOptions = () => {
  let displayedOptions = [];
  let selectOptions = getElementSelectOptions();

  selectOptions.querySelectorAll("li").forEach((option) => {
    displayedOptions.push({ id: option.dataset.id, name: option.textContent });
  });

  return displayedOptions;
};

const renderComponent = (additionalProps = {}) => {
  const fixedProps = {
    options: options,
    currentSelectedOptionIndex: currentSelectedOptionIndex,
    onClick: onClick,
  };
  const props = {...fixedProps, ...additionalProps };

  return render(<SelectOptions {...props} />);
};
