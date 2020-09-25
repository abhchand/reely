import React from 'react';

const Empty = (_props) => {
  return (
    <div
      className='photo-manager photo-manager--emtpy'
      tabIndex='-1'
      role='presentation'>
      <div className='heading'>
        {I18n.t('components.photo_manager.empty.heading')}
      </div>

      <a href='/photos/new' className='add-photos'>
        <button className='cta cta-green' type='button'>
          {I18n.t('components.photo_manager.empty.add_photos')}
        </button>
      </a>
    </div>
  );
};

export default Empty;
