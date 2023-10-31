# frozen_string_literal: true

class ConvertYamlDataToJson4PaperTrail < ActiveRecord::Migration[7.1]
  def change
    add_column :versions, :new_object, :json # or :jsonb
    # add_column :versions, :new_object_changes, :json # or :jsonb

    # PaperTrail::Version.reset_column_information # needed for rails < 6

    PaperTrail::Version.where.not(object: nil).find_each do |version|
      version.update_column(:new_object, YAML.unsafe_load(version.object))

      # if version.object_changes
      #   version.update_column(
      #     :new_object_changes,
      #     YAML.load(version.object_changes)
      #   )
      # end
    end

    remove_column :versions, :object
    # remove_column :versions, :object_changes
    rename_column :versions, :new_object, :object
    # rename_column :versions, :new_object_changes, :object_changes
  end
end
