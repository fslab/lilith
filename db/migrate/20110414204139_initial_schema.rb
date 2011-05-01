# encoding: UTF-8
=begin
Copyright Alexander E. Fischer <aef@raxys.net>, 2011

This file is part of Lilith.

Lilith is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Lilith is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Lilith.  If not, see <http://www.gnu.org/licenses/>.
=end

class InitialSchema < ActiveRecord::Migration

  def self.up
    create_table :people, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type(:for_migration)
      t.string :title
      t.string :forename
      t.string :middlename
      t.string :surname
      t.string :eva_id
      t.string :profile_url
      t.timestamps
    end

    create_table :weeks, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type(:for_migration)
      t.integer :year
      t.integer :index
      t.timestamps
    end

    create_table :categories, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type(:for_migration)
      t.string :name
      t.string :eva_id
      t.timestamps
    end

    create_table :semesters, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type(:for_migration)
      t.integer :start_year
      t.string  :season
      t.string  :start_week
      t.string  :end_week
      t.timestamps
    end

    create_table :schedules, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type(:for_migration)
      t.column :semester_id, Lilith.db_reference_type
      t.timestamps
    end

    create_table :study_units, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type(:for_migration)
      t.column :semester_id, Lilith.db_reference_type
      t.string  :program
      t.integer :position
      t.string  :eva_id
      t.timestamps
    end

    create_table :courses, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type(:for_migration)
      t.column :study_unit_id, Lilith.db_reference_type
      t.string :name
      t.string :profile_url
      t.timestamps
    end

    create_table :events, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type(:for_migration)
      t.column :course_id, Lilith.db_reference_type
      t.column :schedule_id, Lilith.db_reference_type
      t.datetime :first_start
      t.datetime :first_end
      t.date     :until
      t.string   :room
      t.string   :recurrence
      t.timestamps
    end

    create_table :groups, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type(:for_migration)
      t.column :course_id, Lilith.db_reference_type
      t.string :name
      t.timestamps
    end

    create_table :event_group_associations, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type(:for_migration)
      t.column :event_id, Lilith.db_reference_type
      t.column :group_id, Lilith.db_reference_type
      t.timestamps
    end

    create_table :event_lecturer_associations, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type(:for_migration)
      t.column :event_id, Lilith.db_reference_type
      t.column :lecturer_id, Lilith.db_reference_type
      t.timestamps
    end

    add_index :event_lecturer_associations, :event_id
    add_index :event_lecturer_associations, :lecturer_id

    create_table :event_week_associations, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type(:for_migration)
      t.column :event_id, Lilith.db_reference_type
      t.column :week_id, Lilith.db_reference_type
      t.timestamps
    end

    add_index :event_week_associations, :event_id
    add_index :event_week_associations, :week_id

    create_table :category_event_associations, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type(:for_migration)
      t.column :category_id, Lilith.db_reference_type
      t.column :event_id, Lilith.db_reference_type
      t.timestamps
    end

    add_index :category_event_associations, :category_id
    add_index :category_event_associations, :event_id

    create_table :articles, :id => false do |t|
      t.column   :id, Lilith.db_primary_key_type(:for_migration)
      t.datetime :published_at
      t.boolean  :sticky, :default => false
      t.timestamps
    end

    create_table:article_translations, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type(:for_migration)
      t.column :article_id, Lilith.db_reference_type
      t.string :locale
      t.string :name
      t.text   :abstract
      t.text   :body
      t.timestamps
    end

    add_index :article_translations, [:article_id, :locale], :unique => true
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
