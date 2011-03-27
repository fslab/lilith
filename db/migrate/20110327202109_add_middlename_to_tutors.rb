class AddMiddlenameToTutors < ActiveRecord::Migration
  def self.up
    add_column :tutors, :middlename, :string
  end

  def self.down
    remove_column :tutors, :middlename
  end
end
