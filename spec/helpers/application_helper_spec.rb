require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#action_notifications' do
    it 'transforms an action notification hash' do
      msg = 'Some error'
      action_notifications = { 'error' => msg }

      assign(:action_notifications, action_notifications)

      expect(helper.action_notification_props).to eq(
        [{ id: msg.object_id, content: msg, type: 'error' }]
      )
    end

    it 'handles undefined action_notifications' do
      expect(helper.action_notification_props).to eq([])
    end

    it 'handles arrays of strings' do
      msg = 'Some error'
      other_msg = 'Some other error'
      action_notifications = { 'error' => [msg, other_msg] }

      assign(:action_notifications, action_notifications)

      expect(helper.action_notification_props).to eq(
        [
          { id: msg.object_id, content: msg, type: 'error' },
          { id: other_msg.object_id, content: other_msg, type: 'error' }
        ]
      )
    end

    it 'handles symbol keys' do
      msg = 'Some error'
      action_notifications = { error: msg }

      assign(:action_notifications, action_notifications)

      expect(helper.action_notification_props).to eq(
        [{ id: msg.object_id, content: msg, type: 'error' }]
      )
    end
  end
end
