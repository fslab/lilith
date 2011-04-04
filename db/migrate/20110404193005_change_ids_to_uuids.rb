class ChangeIdsToUuids < ActiveRecord::Migration
  def self.up
    tables = [
      :categories,
      :category_event_associations,
      :courses,
      :events,
      :event_group_associations,
      :event_tutor_associations,
      :groups,
      :schedules,
      :semesters,
      :study_units,
      :tutors
    ]

    tables.each do |table|
      remove_column table, :id
      add_column table, :id, :uuid

      execute %{ALTER TABLE "#{table}" ADD PRIMARY KEY (id)}
    end

    remove_column :category_event_associations, :category_id
    remove_column :category_event_associations, :event_id
    add_column :category_event_associations, :category_id, :uuid
    add_column :category_event_associations, :event_id, :uuid

    remove_column :courses, :study_unit_id
    add_column :courses, :study_unit_id, :uuid

    remove_column :events, :course_id
    remove_column :events, :schedule_id
    add_column :events, :course_id, :uuid
    add_column :events, :schedule_id, :uuid

    remove_column :event_group_associations, :event_id
    remove_column :event_group_associations, :group_id
    add_column :event_group_associations, :event_id, :uuid
    add_column :event_group_associations, :group_id, :uuid

    remove_column :event_tutor_associations, :event_id
    remove_column :event_tutor_associations, :tutor_id
    add_column :event_tutor_associations, :event_id, :uuid
    add_column :event_tutor_associations, :tutor_id, :uuid

    remove_column :groups, :course_id
    add_column :groups, :course_id, :uuid

    remove_column :schedules, :study_unit_id
    add_column :schedules, :study_unit_id, :uuid

    remove_column :study_units, :semester_id
    add_column :study_units, :semester_id, :uuid
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
