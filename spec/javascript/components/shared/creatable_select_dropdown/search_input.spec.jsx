import { cleanup, fireEvent, render } from "react-testing-library";
import KeyCodes from "test_utils/key_codes";
import React from "react";
import SearchInput from "components/shared/creatable_select_dropdown/search_input";

let rendered;

let options;
let filteredOptions;
let currentSelectedOptionIndex;
let onChange;
let onKeyEnter;
let onKeyEscape;
let onKeyArrowDown;
let onKeyArrowUp;

const defaults = SearchInput.defaultProps;

beforeEach(() => {
  options = [
    { id: "TN", name: "Tamil Nadu" },
    { id: "MH", name: "Maharashtra" },
    { id: "KL", name: "Kerala" }
  ];

  filteredOptions = options;
  currentSelectedOptionIndex = 0;

  onChange = jest.fn();
  onKeyEnter = jest.fn();
  onKeyEscape = jest.fn();
  onKeyArrowDown = jest.fn();
  onKeyArrowUp = jest.fn();
});

afterEach(cleanup);

describe("<SearchInput />", () => {
  it("renders the component", () => {
    rendered = renderComponent();

    const input = getElementInput();

    expect(input).not.toBeNull();
    expect(input).toHaveAttribute("placeholder", defaults.placeholder);
  });

  describe("placeholder prop", () => {
    it("overrides the default placeholder when present", () => {
      rendered = renderComponent({ placeholder: "foo" });

      const input = getElementInput();

      expect(input).not.toBeNull();
      expect(input).toHaveAttribute("placeholder", "foo");
    });
  });

  describe("input keyDown event", () => {
    it("calls the appropriate *keyDown handler", () => {
      const filteredOptions = [{ id: "TN", name: "Tamil Nadu" }, { id: "KL", name: "Kerala" }];
      const currentSelectedOptionIndex = 1;

      rendered = renderComponent({
        filteredOptions: filteredOptions,
        currentSelectedOptionIndex: currentSelectedOptionIndex
      });

      const input = getElementInput();

      // Enter Key
      expect(onKeyEnter).not.toHaveBeenCalled();
      fireEvent.keyDown(input, KeyCodes.ENTER);
      expect(onKeyEnter).toHaveBeenCalled();
      expect(onKeyEnter.mock.calls[0]).toMatchObject(["KL"]);

      // Escape Key
      expect(onKeyEscape).not.toHaveBeenCalled();
      fireEvent.keyDown(input, KeyCodes.ESCAPE);
      expect(onKeyEscape).toHaveBeenCalled();

      // Down Arrow Key
      expect(onKeyArrowDown).not.toHaveBeenCalled();
      fireEvent.keyDown(input, KeyCodes.ARROW_DOWN);
      expect(onKeyArrowDown).toHaveBeenCalled();

      // Up Arrow Key
      expect(onKeyArrowUp).not.toHaveBeenCalled();
      fireEvent.keyDown(input, KeyCodes.ARROW_UP);
      expect(onKeyArrowUp).toHaveBeenCalled();
    });
  });

  describe("input keyChange event", () => {
    it("filters and highlights the options based on the query and calls the onChange handler", () => {
      rendered = renderComponent();

      expect(onChange).not.toHaveBeenCalled();
      searchFor("ra");
      expect(onChange).toHaveBeenCalled();

      const expected = [
        { id: "MH", name: "Maharashtra", html: <span>Maha<span className="highlight">ra</span>shtra</span> },
        { id: "KL", name: "Kerala", html: <span>Ke<span className="highlight">ra</span>la</span> }
      ];

      expect(onChange.mock.calls[0]).toMatchObject(["ra", expected]);
    });

    describe("filtering options", () => {
      it("only highlights the first instance", () => {
        // This is basically identical to the test above. Leave it as is
        // so it's explicitly a separate test, especially since it
        // doesn't cost much to re-run it. Update in the future as needed

        rendered = renderComponent();

        expect(onChange).not.toHaveBeenCalled();
        searchFor("ra");
        expect(onChange).toHaveBeenCalled();

        const expected = [
          { id: "MH", name: "Maharashtra", html: <span>Maha<span className="highlight">ra</span>shtra</span> },
          { id: "KL", name: "Kerala", html: <span>Ke<span className="highlight">ra</span>la</span> }
        ];

        expect(onChange.mock.calls[0]).toMatchObject(["ra", expected]);
      });

      it("is case insensitive", () => {
        rendered = renderComponent();

        expect(onChange).not.toHaveBeenCalled();
        searchFor("NA");
        expect(onChange).toHaveBeenCalled();

        const expected = [
          { id: "TN", name: "Tamil Nadu", html: <span>Tamil <span className="highlight">Na</span>du</span> },
        ];

        expect(onChange.mock.calls[0]).toMatchObject(["NA", expected]);
      });

      it("ignores leading or trailing whitespace", () => {
        rendered = renderComponent();

        expect(onChange).not.toHaveBeenCalled();
        searchFor(" mil ");
        expect(onChange).toHaveBeenCalled();

        const expected = [
          { id: "TN", name: "Tamil Nadu", html: <span>Ta<span className="highlight">mil</span> Nadu</span> },
        ];

        expect(onChange.mock.calls[0]).toMatchObject([" mil ", expected]);
      });

      it("clearing the input resets the options", () => {
        rendered = renderComponent();

        searchFor("Ta");
        searchFor("");

        const expected = [
          { id: "TN", name: "Tamil Nadu", html: <span>Tamil Nadu</span> },
          { id: "MH", name: "Maharashtra", html: <span>Maharashtra</span> },
          { id: "KL", name: "Kerala", html: <span>Kerala</span> }
        ];

        expect(onChange.mock.calls[1]).toMatchObject(["", expected]);
      });
    });
  });
});

const getElementInput = () => (rendered.getByTestId("search-input").querySelector("input"));

const searchFor = (query) => {
  let input = getElementInput();
  fireEvent.change(input, { target: { value: query } });
};

const renderComponent = (additionalProps = {}) => {
  const fixedProps = {
    options: options,
    filteredOptions: filteredOptions,
    currentSelectedOptionIndex: currentSelectedOptionIndex,
    onChange: onChange,
    onKeyEnter: onKeyEnter,
    onKeyEscape: onKeyEscape,
    onKeyArrowDown: onKeyArrowDown,
    onKeyArrowUp: onKeyArrowUp
  };
  const props = {...fixedProps, ...additionalProps };

  return render(<SearchInput {...props} />);
};
