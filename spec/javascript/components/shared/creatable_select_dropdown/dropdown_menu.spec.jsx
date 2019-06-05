import { cleanup, fireEvent, render } from "react-testing-library";
import DropdownMenu from "components/shared/creatable_select_dropdown/dropdown_menu";
import KeyCodes from "test_utils/key_codes";
import React from "react";

let rendered;

let options;
let closeMenu;
let handleSelect;
let handleCreate;

beforeEach(() => {
  options = [
    { id: "TN", name: "Tamil Nadu" },
    { id: "MH", name: "Maharashtra" },
    { id: "KL", name: "Kerala" }
  ];

  closeMenu = jest.fn();
  handleSelect = jest.fn();
  handleCreate = jest.fn();
});

afterEach(cleanup);

describe("<DropdownMenu />", () => {
  it("renders the component", () => {
    rendered = renderComponent();

    const searchInput = getElementSearchInput();
    const selectOptions = getElementSelectOptions();
    const createOption = getElementCreateOption();

    expect(rendered.container).toContainElement(searchInput);
    expect(rendered.container).toContainElement(selectOptions);
    expect(rendered.container).not.toContainElement(createOption);

    expect(displayedOptions()).toMatchObject(options);
  });

  describe("text value props", () => {
    it("overrides the text values correctly in the child components", () => {
      rendered = renderComponent({
        options: [], // force <SelectOpions /> to display empty state
        textForOptionsEmptyState: "some empty state",
        textForSearchInputPlaceholder: "some placeholder",
        textGeneratorForCreateOption: (text) => (`${text}-foo`)
      });

      // First force <CreateOption /> to render by typing in something
      searchFor("abcd");

      const searchInput = getElementSearchInput();
      const selectOptions = getElementSelectOptions();
      const createOption = getElementCreateOption();

      // Test that text lables are rendered
      expect(searchInput).toHaveAttribute("placeholder", "some placeholder");
      expect(selectOptions).toHaveTextContent("some empty state");
      expect(createOption).toHaveTextContent("abcd-foo");
    });
  });

  describe("searching for options", () => {
    it("the component updates while typing", () => {
      rendered = renderComponent();

      searchFor("ra");

      let expected = [{ id: "MH", name: "Maharashtra" }, { id: "KL", name: "Kerala" }];

      const searchInput = getElementSearchInput();
      const createOption = getElementCreateOption();

      expect(searchInput.value).toBe("ra");
      expect(displayedOptions()).toMatchObject(expected);
      expect(createOption).toHaveTextContent("Create 'ra'");
    });

    it("selected option resets to first option with each input change", () => {
      rendered = renderComponent();

      pressArrowDownOnSearchInpupt();
      expectCurrentSelectedOptionToBe("MH");

      searchFor("a");
      expectCurrentSelectedOptionToBe("TN");
    });

    it("clearing the input resets the component", () => {
      rendered = renderComponent();

      const searchInput = getElementSearchInput();
      searchFor("ra");
      searchFor("" );

      const createOption = getElementCreateOption();

      expect(searchInput.value).toBe("");
      expect(displayedOptions()).toMatchObject(options);
      expect(createOption).toBeNull();
    });
  });

  describe("keyboard navigation", () => {
    it("options can be navigated with the up/down arrow", () => {
      rendered = renderComponent();

      pressArrowDownOnSearchInpupt();
      expectCurrentSelectedOptionToBe("MH");

      pressArrowDownOnSearchInpupt();
      expectCurrentSelectedOptionToBe("KL");

      pressArrowDownOnSearchInpupt();
      expectCurrentSelectedOptionToBe("KL");

      pressArrowUpOnSearchInput();
      expectCurrentSelectedOptionToBe("MH");

      pressArrowUpOnSearchInput();
      expectCurrentSelectedOptionToBe("TN");

      pressArrowUpOnSearchInput();
      expectCurrentSelectedOptionToBe("TN");
    });
  });
});

const getElementSearchInput = () => (rendered.queryByTestId("search-input").querySelector("input"));
const getElementSelectOptions = () => (rendered.queryByTestId("select-options"));
const getElementCreateOption = () => (rendered.queryByTestId("create-option"));

const pressArrowUpOnSearchInput = () => {
  let searchInput = getElementSearchInput();
  return fireEvent.keyDown(searchInput, KeyCodes.ARROW_UP);
};

const pressArrowDownOnSearchInpupt = () => {
  let searchInput = getElementSearchInput();
  return fireEvent.keyDown(searchInput, KeyCodes.ARROW_DOWN);
};

const expectCurrentSelectedOptionToBe = (expectedOptionId) => {
  let selectOptions = getElementSelectOptions();
  let currentSelectedOption = selectOptions.querySelector("li.selected").dataset.id;

  expect(currentSelectedOption).toEqual(expectedOptionId);
};

const searchFor = (text) => {
  let searchInput = getElementSearchInput();
  fireEvent.change(searchInput, { target: { value: text } });
};

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
    closeMenu: closeMenu,
    handleSelect: handleSelect,
    handleCreate: handleCreate
  };
  const props = {...fixedProps, ...additionalProps };

  return render(<DropdownMenu {...props} />);
};
