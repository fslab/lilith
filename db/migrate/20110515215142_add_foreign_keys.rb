class AddForeignKeys < ActiveRecord::Migration
  def self.up
    add_foreign_key :schedules, :semesters, :dependent => :restrict
    add_foreign_key :study_units, :semesters, :dependent => :restrict
    add_foreign_key :courses, :study_units, :dependent => :restrict
    add_foreign_key :events, :courses, :dependent => :restrict
    add_foreign_key :events, :schedules, :dependent => :restrict
    add_foreign_key :groups, :courses, :dependent => :restrict
    add_foreign_key :event_group_associations, :events, :dependent => :restrict
    add_foreign_key :event_group_associations, :groups, :dependent => :restrict
    add_foreign_key :event_lecturer_associations, :events, :dependent => :restrict
    add_foreign_key :event_lecturer_associations, :people, :column => 'lecturer_id', :dependent => :restrict
    add_foreign_key :event_week_associations, :events, :dependent => :restrict
    add_foreign_key :event_week_associations, :weeks, :dependent => :restrict
    add_foreign_key :category_event_associations, :categories, :dependent => :restrict
    add_foreign_key :category_event_associations, :events, :dependent => :restrict
    add_foreign_key :article_translations, :articles, :dependent => :restrict
  end

  def self.down
    remove_foreign_key :article_translations, :articles
    remove_foreign_key :category_event_associations, :events
    remove_foreign_key :category_event_associations, :categories
    remove_foreign_key :event_week_associations, :weeks
    remove_foreign_key :event_week_associations, :events
    remove_foreign_key :event_lecturer_associations, :column => 'lecturer_id'
    remove_foreign_key :event_lecturer_associations, :events
    remove_foreign_key :event_group_associations, :groups
    remove_foreign_key :event_group_associations, :events
    remove_foreign_key :groups, :courses
    remove_foreign_key :events, :schedules
    remove_foreign_key :events, :courses
    remove_foreign_key :courses, :study_units
    remove_foreign_key :study_units, :semesters
    remove_foreign_key :schedules, :semesters
  end
end
