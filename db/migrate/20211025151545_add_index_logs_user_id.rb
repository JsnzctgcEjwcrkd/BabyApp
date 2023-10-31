# frozen_string_literal: true

class AddIndexLogsUserId < ActiveRecord::Migration[6.1]
  def change
    add_index :logs, :user_id
  end
end
