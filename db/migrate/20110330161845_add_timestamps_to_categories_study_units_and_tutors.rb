class AddTimestampsToCategoriesStudyUnitsAndTutors < ActiveRecord::Migration
  def self.up
    add_column :categories, :created_at, :datetime
    add_column :categories, :updated_at, :datetime

    add_column :study_units, :created_at, :datetime
    add_column :study_units, :updated_at, :datetime

    add_column :tutors, :created_at, :datetime
    add_column :tutors, :updated_at, :datetime
  end

  def self.down
    remove_column :tutors, :created_at
    remove_column :tutors, :updated_at
    
    remove_column :study_units, :created_at
    remove_column :study_units, :updated_at

    remove_column :categories, :created_at
    remove_column :categories, :updated_at
  end
end
