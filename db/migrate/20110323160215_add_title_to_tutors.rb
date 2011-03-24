class AddTitleToTutors < ActiveRecord::Migration
  def self.up
    add_column :tutors, :title, :string
  end

  def self.down
    remove_columns :tutors, :title
  end
end