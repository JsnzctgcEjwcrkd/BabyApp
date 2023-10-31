# frozen_string_literal: true

class AddIndexLogsDateTime < ActiveRecord::Migration[6.1]
  def change
    add_index :logs, %i[date_time log_type]
  end
end
