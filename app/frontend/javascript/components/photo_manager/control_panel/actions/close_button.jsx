import { IconX } from 'components/icons';
import PropTypes from 'prop-types';
import React from 'react';

const CloseButton = (props) => {
  return (
    <li
      tabIndex={0}
      className='icon-tray__item icon-tray__item--close-control-panel'
      onClick={props.onClick}
      onKeyPress={props.onClick}>
      <IconX
        size='18'
        fillColor='#888888'
        title={I18n.t(
          'components.photo_manager.control_panel.close_button.alt'
        )}
      />
    </li>
  );
};

CloseButton.propTypes = {
  onClick: PropTypes.func.isRequired
};

export default CloseButton;
