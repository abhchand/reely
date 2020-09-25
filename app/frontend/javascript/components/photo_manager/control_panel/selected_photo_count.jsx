import PropTypes from 'prop-types';
import React from 'react';

const SelectedPhotoCount = (props) => {
  const key = props.count !== 1 ? 'other' : 'one';

  return (
    <div className='photo-grid-control-panel__selected-photo-count'>
      <span>
        {I18n.t(
          `components.photo_manager.control_panel.selected_photo_count.heading.${key}`,
          { count: props.count }
        )}
      </span>
    </div>
  );
};

SelectedPhotoCount.propTypes = {
  count: PropTypes.number.isRequired
};

export default SelectedPhotoCount;
