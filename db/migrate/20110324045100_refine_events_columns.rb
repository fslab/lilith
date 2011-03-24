class RefineEventsColumns < ActiveRecord::Migration
  def self.up
    add_column :events, :first_start, :datetime
    add_column :events, :first_end, :datetime
    add_column :events, :until, :date
    remove_column :events, :name
  end

  def self.down
    add_column :events, :name, :string
    remove_column :events, :until
    remove_column :events, :first_end
    remove_column :events, :first_start
  end
end
