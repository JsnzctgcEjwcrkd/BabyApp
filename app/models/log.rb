# frozen_string_literal: true

class Log < ApplicationRecord
  acts_as_taggable

  attr_accessor :add_urine

  belongs_to :user

  has_paper_trail

  validates :description, length: { maximum: 500 }
  validates :tag_list, length: { maximum: 500 }

  def self.ransackable_attributes(_auth_object = nil)
    ['description']
  end
end
