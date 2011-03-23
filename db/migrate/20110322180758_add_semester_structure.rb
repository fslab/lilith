class AddSemesterStructure < ActiveRecord::Migration
  def self.up
    create_table :semesters do |t|
      t.string :study_program
      t.string :study_unit
      t.string :study_year
      t.timestamps
    end

    create_table :plans do |t|
      t.belongs_to :semester
      t.timestamps
    end

    create_table :courses do |t|
      t.belongs_to :plan
      t.string :name
      t.string :profile_url
      t.timestamps
    end

    create_table :groups do |t|
      t.belongs_to :course
      t.string :name
      t.timestamps
    end

    create_table :events do |t|
      t.belongs_to :course
      t.string :name
      t.string :room
      t.string :recurrence
      t.timestamps
    end

    create_table :event_group_associations do |t|
      t.belongs_to :event
      t.belongs_to :group
    end

    create_table :tutors do |t|
      t.string :forename
      t.string :surname
      t.string :eva_marker
      t.string :profile_url
    end

    create_table :event_tutor_associations do |t|
      t.belongs_to :event
      t.belongs_to :tutor
    end
  end

  def self.down
    drop_table :event_tutor_associations
    drop_table :tutors
    drop_table :event_group_associations
    drop_table :events
    drop_table :groups
    drop_table :courses
    drop_table :plans
    drop_table :semesters
  end
end
