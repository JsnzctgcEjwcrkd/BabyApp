# frozen_string_literal: true

class AddColumnToLogs < ActiveRecord::Migration[6.1]
  def change
    add_column :logs, :user_id, :integer
  end
end
