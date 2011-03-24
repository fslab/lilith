class CreateStudyUnitsAndModifySemesters < ActiveRecord::Migration
  def self.up
    create_table :study_units do |t|
      t.belongs_to :semester
      t.string :program
      t.integer :position
      t.string :eva_id
    end

    remove_column :semesters, :study_program
    remove_column :semesters, :study_unit
    remove_column :semesters, :study_year
    remove_column :semesters, :eva_marker

    add_column :semesters, :begin_year, :date
    add_column :semesters, :season, :string

    rename_column :plans, :semester_id, :study_unit_id
  end

  def self.down
    rename_column :plans, :study_unit_id, :semester_id

    remove_column :semesters, :season
    remove_column :semesters, :begin_year

    add_column :semesters, :eva_marker, :string
    add_column :semesters, :study_year, :string
    add_column :semesters, :study_unit, :string
    add_column :semesters, :study_program, :string

    drop_table :study_units
  end
end
