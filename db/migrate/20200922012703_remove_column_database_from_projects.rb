class RemoveColumnDatabaseFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :database, :string
  end
end
