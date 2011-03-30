class ChangeBeginYearOnSemesters < ActiveRecord::Migration
  def self.up
    remove_column(:semesters, :begin_year)
    add_column(:semesters, :start_year, :integer)
  end

  def self.down
    remove_column(:semesters, :start_year, :integer)
    add_column(:semesters, :begin_year, :date)
  end
end
