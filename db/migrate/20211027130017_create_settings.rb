# frozen_string_literal: true

class CreateSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :settings do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :birth_day
      t.decimal :latitude
      t.decimal :longitude
      t.boolean :night_mode, null: false, default: false
      t.string :border_line, default: '8,16'
      t.integer :milk_default, null: false, default: 80
      t.integer :milk_min, null: false, default: 10
      t.integer :milk_max, null: false, default: 200
      t.integer :stool_color_default, null: false, default: 6
      t.float :body_temp_default, null: false, default: 37.0

      t.timestamps
    end
  end
end
