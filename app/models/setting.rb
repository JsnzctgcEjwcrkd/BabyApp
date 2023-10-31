# frozen_string_literal: true

class Setting < ApplicationRecord
  belongs_to :user

  validates :birth_day, presence: true
  validates :border_line, presence: true
  validates :milk_default, presence: true
  validates :milk_min, presence: true
  validates :milk_max, presence: true
  validates :stool_color_default, presence: true
  validates :body_temp_default, presence: true
end
