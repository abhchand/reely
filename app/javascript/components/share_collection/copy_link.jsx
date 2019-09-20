import {IconCopy} from "components/icons";
import React from "react";

class CopyLink extends React.Component {
  constructor(props) {
    super(props);

    this.onClick = this.onClick.bind(this);

    this.i18nPrefix = "components.share_collection.copy_link";
  }

  onClick() {
    const copyTextarea = document.querySelector(".share-collection__url");
    copyTextarea.focus();
    copyTextarea.select();

    try {
      document.execCommand('copy');

      const id = `id${  Math.random().toString(16).slice(2)}`;
      const content = I18n.t(`${this.i18nPrefix  }.success`);
      const notification = { id: id, content: content, type: "success" };

      // HTML page is expected to have loaded the `<ActionNotifications />`
      // component separately
      window.action_notifications.add(notification);
    } catch (err) {
      // eslint-disable-next-line no-empty
    }
  }

  render() {
    return (
      <button
        data-testid="copy-link"
        type="button"
        className="share-collection__link-sharing-copy"
        onClick={this.onClick}>
        <div className="button-contents">
          <IconCopy size="22px" fillColor="#000000" />
          <span>{I18n.t(`${this.i18nPrefix  }.label`)}</span>
        </div>
      </button>
    );
  }
}

export default CopyLink;
