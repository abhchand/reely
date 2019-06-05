import { cleanup, fireEvent, render } from "react-testing-library";
import CreatableSelectDropdown from "components/shared/creatable_select_dropdown/creatable_select_dropdown";
import KeyCodes from "test_utils/key_codes";
import React from "react";

let rendered;

let options;
let onCreate;
let onSelect;

beforeEach(() => {
  options = [
    { id: "TN", name: "Tamil Nadu" },
    { id: "MH", name: "Maharashtra" },
    { id: "KL", name: "Kerala" }
  ];

  onCreate = jest.fn();
  onSelect = jest.fn();
});

afterEach(cleanup);

describe("<CreatableSelectDropdown />", () => {
  it("renders the component with menu closed", () => {
    rendered = renderComponent();

    const component = rendered.container;

    expect(component).toContainElement(getElementOpenMenuButton());
    expect(component).not.toContainElement(getElementCloseMenuButton());
    expect(component).not.toContainElement(getElementDropdownMenu());
  });

  describe("opening the dropdown menu", () => {
    it("user can open menu onClick", () => {
      rendered = renderComponent();

      clickOpenMenuButton();
      const component = rendered.container;

      expect(component).not.toContainElement(getElementOpenMenuButton());
      expect(component).toContainElement(getElementCloseMenuButton());
      expect(component).toContainElement(getElementDropdownMenu());
    });

    it("user can open menu onKeyPress Enter", () => {
      rendered = renderComponent();

      fireEvent.keyPress(getElementOpenMenuButton(), KeyCodes.ENTER);
      const component = rendered.container;

      expect(component).not.toContainElement(getElementOpenMenuButton());
      expect(component).toContainElement(getElementCloseMenuButton());
      expect(component).toContainElement(getElementDropdownMenu());
    });
  });

  describe("closing the dropdown menu", () => {
    it("user can open menu onClick", () => {
      rendered = renderComponent();

      clickOpenMenuButton();
      clickCloseMenuButton();

      const component = rendered.container;

      expect(component).toContainElement(getElementOpenMenuButton());
      expect(component).not.toContainElement(getElementCloseMenuButton());
      expect(component).not.toContainElement(getElementDropdownMenu());
    });

    it("user can close menu onKeyPress Enter", () => {
      rendered = renderComponent();

      clickOpenMenuButton();
      fireEvent.keyPress(getElementCloseMenuButton(), KeyCodes.ENTER);

      const component = rendered.container;

      expect(component).toContainElement(getElementOpenMenuButton());
      expect(component).not.toContainElement(getElementCloseMenuButton());
      expect(component).not.toContainElement(getElementDropdownMenu());
    });
  });

  it("user can search and filter options", () => {
    rendered = renderComponent();

    clickOpenMenuButton();
    searchFor("ra");

    expect(getElementSearchInput().value).toBe("ra");
    expect(displayedOptions()).toMatchObject([{ id: "MH", name: "Maharashtra" }, { id: "KL", name: "Kerala" }]);
  });

  describe("selecting options", () => {
    it("user can select an option onClick", () => {
      rendered = renderComponent();

      clickOpenMenuButton();

      expect(onSelect).not.toHaveBeenCalled();
      expect(onCreate).not.toHaveBeenCalled();

      fireEvent.click(getOption("MH"));

      expect(onSelect).toHaveBeenCalled();
      expect(onSelect.mock.calls[0]).toMatchObject(["MH"]);
      expect(onCreate).not.toHaveBeenCalled();
    });

    it("user can select an option onKeyDown Enter", () => {
      rendered = renderComponent();

      clickOpenMenuButton();

      expect(onSelect).not.toHaveBeenCalled();
      expect(onCreate).not.toHaveBeenCalled();

      pressArrowDownOnSearchInpupt();
      fireEvent.keyDown(getElementSearchInput(), KeyCodes.ENTER);

      expect(onSelect).toHaveBeenCalled();
      expect(onSelect.mock.calls[0]).toMatchObject(["MH"]);
      expect(onCreate).not.toHaveBeenCalled();
    });
  });

  describe("create new option", () => {
    it("user can create a new option onClick", () => {
      rendered = renderComponent();

      clickOpenMenuButton();

      expect(onSelect).not.toHaveBeenCalled();
      expect(onCreate).not.toHaveBeenCalled();

      searchFor("abcde");
      fireEvent.click(getElementCreateOption());

      expect(onSelect).not.toHaveBeenCalled();
      expect(onCreate).toHaveBeenCalled();
      expect(onCreate.mock.calls[0]).toMatchObject(["abcde"]);
    });

    it("user can create a new option onKeyDown Enter", () => {
      rendered = renderComponent();

      clickOpenMenuButton();

      expect(onSelect).not.toHaveBeenCalled();
      expect(onCreate).not.toHaveBeenCalled();

      searchFor("abcde");
      fireEvent.keyDown(getElementCreateOption(), KeyCodes.ENTER);

      expect(onSelect).not.toHaveBeenCalled();
      expect(onCreate).toHaveBeenCalled();
      expect(onCreate.mock.calls[0]).toMatchObject(["abcde"]);
    });
  });

  describe("text props", () => {
    it("overrides the default text props when present", () => {
      rendered = renderComponent({
        textForCloseMenuButton: "foo close",
        textForOptionsEmptyState: "foo empty",
        textForSearchInputPlaceholder: "foo search",
        textGeneratorForCreateOption: ((text) => (`foo ${text}`))
      });

      clickOpenMenuButton();

      // textForCloseMenuButton
      expect(getElementCloseMenuButton()).toHaveTextContent("foo close");

      // textForSearchInputPlaceholder
      expect(getElementSearchInput()).toHaveAttribute("placeholder", "foo search");

      // textForOptionsEmptyState
      searchFor("zzzz");
      expect(getElementSelectOptions()).toHaveTextContent("foo empty");

      // textGeneratorForCreateOption
      expect(getElementCreateOption()).toHaveTextContent("foo zzzz");
    });
  });
});

const getElementOpenMenuButton = () => (rendered.queryByTestId("open-menu-button"));
const getElementCloseMenuButton = () => (rendered.queryByTestId("close-menu-button"));
const getElementDropdownMenu = () => (rendered.queryByTestId("dropdown-menu"));
const getElementSearchInput = () => (rendered.getByTestId("search-input").querySelector("input"));
const getElementCreateOption = () => (rendered.getByTestId("create-option"));
const getElementSelectOptions = () => (rendered.getByTestId("select-options"));

const clickOpenMenuButton = () => (fireEvent.click(getElementOpenMenuButton()));
const clickCloseMenuButton = () => (fireEvent.click(getElementCloseMenuButton()));

// eslint-disable-next-line no-unused-vars
const pressArrowUpOnSearchInput = () => {
  let searchInput = getElementSearchInput();
  return fireEvent.keyDown(searchInput, KeyCodes.ARROW_UP);
};

const pressArrowDownOnSearchInpupt = () => {
  let searchInput = getElementSearchInput();
  return fireEvent.keyDown(searchInput, KeyCodes.ARROW_DOWN);
};

const getOption = (optionId) => (rendered.getByTestId("select-options").querySelector(`li[data-id="${optionId}"] div`));
const searchFor = (query) => (fireEvent.change(getElementSearchInput(), { target: { value: query } }));


const displayedOptions = () => {
  let displayedOptions = [];
  let selectOptions = getElementSelectOptions();

  selectOptions.querySelectorAll("li").forEach((option) => {
    displayedOptions.push({ id: option.dataset.id, name: option.textContent });
  });

  return displayedOptions;
};

const renderComponent = (additionalProps = {}) => {
  const fixedProps = { options: options, onCreate: onCreate, onSelect: onSelect };
  const props = {...fixedProps, ...additionalProps };

  return render(<CreatableSelectDropdown {...props} />);
};
