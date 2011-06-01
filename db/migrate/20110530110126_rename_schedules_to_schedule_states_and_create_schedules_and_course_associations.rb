class RenameSchedulesToScheduleStatesAndCreateSchedulesAndCourseAssociations < ActiveRecord::Migration
  def self.up
    rename_table :schedules, :schedule_states
    rename_column :events, :schedule_id, :schedule_state_id

    create_table :schedules, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type
      t.column :user_id, Lilith.db_reference_type, :null => false
      t.column :schedule_state_id, Lilith.db_reference_type
      t.string :name
      t.text :description
      t.boolean :public, :null => false, :default => false
      t.timestamps :null => false
    end

    add_index :schedules, [:user_id, :name], :unique => true
    add_index :schedules, :user_id

    add_foreign_key :schedules, :schedule_states, :dependent => :restrict
    add_foreign_key :schedules, :users, :dependent => :restrict

    create_table :schedule_course_associations, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type
      t.column :schedule_id, Lilith.db_reference_type, :null => false
      t.column :course_id, Lilith.db_reference_type, :null => false
      t.timestamps :null => false
    end

    add_index :schedule_course_associations, :schedule_id
    add_index :schedule_course_associations, :course_id
    add_index :schedule_course_associations, [:schedule_id, :course_id], :unique => true

    add_foreign_key :schedule_course_associations, :schedules, :dependent => :restrict
    add_foreign_key :schedule_course_associations, :courses, :dependent => :restrict

    add_column :users, :default_schedule_id, Lilith.db_reference_type

    add_foreign_key :users, :schedules, :column => :default_schedule_id, :dependent => :restrict
  end

  def self.down
    remove_foreign_key :users, :column => :default_schedule_id

    remove_column :users, :default_schedule_id

    remove_foreign_key :schedule_course_associations, :courses
    remove_foreign_key :schedule_course_associations, :schedules

    remove_index :schedule_course_associations, [:schedule_id, :course_id]
    remove_index :schedule_course_associations, :course_id
    remove_index :schedule_course_associations, :schedule_id

    drop_table :schedule_course_associations

    remove_foreign_key :schedules, :users
    remove_foreign_key :schedules, :schedule_states

    remove_index :schedules, :user_id
    remove_index :schedules, [:user_id, :name]

    drop_table :schedules

    rename_column :events, :schedule_state_id, :schedule_id
    rename_table :schedule_states, :schedules
  end
end
