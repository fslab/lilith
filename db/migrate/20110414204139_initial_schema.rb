class InitialSchema < ActiveRecord::Migration

  PRIMARY_KEY = 'UUID PRIMARY KEY'
  REFERENCE   = 'UUID'

  def self.up
    create_table :people, :id => false do |t|
      t.string :title
      t.string :forename
      t.string :middlename
      t.string :surname
      t.string :eva_id
      t.string :profile_url
      t.timestamps
    end

    add_column :people, :id, PRIMARY_KEY


    create_table :weeks, :id => false do |t|
      t.integer :year
      t.integer :index
      t.timestamps
    end

    add_column :weeks, :id, PRIMARY_KEY


    create_table :categories, :id => false do |t|
      t.string :name
      t.string :eva_id
      t.timestamps
    end

    add_column :categories, :id, PRIMARY_KEY


    create_table :semesters, :id => false do |t|
      t.integer :start_year
      t.string  :season
      t.string  :start_week
      t.string  :end_week
      t.timestamps
    end

    add_column :semesters, :id, PRIMARY_KEY


    create_table :schedules, :id => false do |t|
      t.timestamps
    end

    add_column :schedules, :id, PRIMARY_KEY
    add_column :schedules, :semester_id, REFERENCE


    create_table :study_units, :id => false do |t|
      t.string  :program
      t.integer :position
      t.string  :eva_id
      t.timestamps
    end

    add_column :study_units, :id, PRIMARY_KEY
    add_column :study_units, :semester_id, REFERENCE


    create_table :courses, :id => false do |t|
      t.string :name
      t.string :profile_url
      t.timestamps
    end

    add_column :courses, :id, PRIMARY_KEY
    add_column :courses, :study_unit_id, REFERENCE


    create_table :events, :id => false do |t|
      t.datetime :first_start
      t.datetime :first_end
      t.date     :until
      t.string   :room
      t.string   :recurrence
      t.timestamps
    end

    add_column :events, :id, PRIMARY_KEY
    add_column :events, :course_id, REFERENCE
    add_column :events, :schedule_id, REFERENCE


    create_table :groups, :id => false do |t|
      t.string :name
      t.timestamps
    end

    add_column :groups, :id, PRIMARY_KEY
    add_column :groups, :course_id, REFERENCE


    create_table :event_group_associations, :id => false do |t|
      t.timestamps
    end

    add_column :event_group_associations, :id, PRIMARY_KEY
    add_column :event_group_associations, :event_id, REFERENCE
    add_column :event_group_associations, :group_id, REFERENCE

    add_index :event_group_associations, :event_id
    add_index :event_group_associations, :group_id


    create_table :event_lecturer_associations, :id => false do |t|
      t.timestamps
    end

    add_column :event_lecturer_associations, :id, PRIMARY_KEY
    add_column :event_lecturer_associations, :event_id, REFERENCE
    add_column :event_lecturer_associations, :lecturer_id, REFERENCE

    add_index :event_lecturer_associations, :event_id
    add_index :event_lecturer_associations, :lecturer_id


    create_table :event_week_associations, :id => false do |t|
      t.timestamps
    end

    add_column :event_week_associations, :id, PRIMARY_KEY
    add_column :event_week_associations, :event_id, REFERENCE
    add_column :event_week_associations, :week_id, REFERENCE

    add_index :event_week_associations, :event_id
    add_index :event_week_associations, :week_id


    create_table :category_event_associations, :id => false do |t|
      t.column :category, REFERENCE
      t.column :event, REFERENCE
      t.timestamps
    end

    add_column :category_event_associations, :id, PRIMARY_KEY
    add_column :category_event_associations, :category_id, REFERENCE
    add_column :category_event_associations, :event_id, REFERENCE

    add_index :category_event_associations, :category_id
    add_index :category_event_associations, :event_id
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
