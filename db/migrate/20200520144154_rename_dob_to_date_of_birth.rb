class RenameDobToDateOfBirth < ActiveRecord::Migration
  def change
    rename_column :users, :dob, :date_of_birth
  end
end
