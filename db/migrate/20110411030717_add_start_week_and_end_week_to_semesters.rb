class AddStartWeekAndEndWeekToSemesters < ActiveRecord::Migration
  def self.up
    add_column :semesters, :start_week, :string
    add_column :semesters, :end_week, :string
  end

  def self.down
    remove_column :semesters, :end_week
    remove_column :semesters, :start_week
  end
end
