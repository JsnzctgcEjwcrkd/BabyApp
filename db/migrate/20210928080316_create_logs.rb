# frozen_string_literal: true

class CreateLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :logs do |t|
      t.integer :log_type
      t.integer :milk_amount
      t.boolean :stool_little
      t.integer :stool_color
      t.float :body_temperature
      t.text :description
      t.datetime :date_time

      t.timestamps
    end
  end
end
