class RenameNatureToProjectType < ActiveRecord::Migration
  def change
    rename_column :projects, :nature, :project_type
  end
end
