class RenameTutorsToLecturerAndEventTutorAssociationsToEventLecturerAssociations < ActiveRecord::Migration
  def self.up
    rename_table(:event_tutor_associations, :event_lecturer_associations)
    rename_table(:tutors, :people)
    rename_column(:event_lecturer_associations, :tutor_id, :lecturer_id)
  end

  def self.down
    rename_column(:event_lecturer_associations, :lecturer_id, :tutor_id)
    rename_table(:people, :tutors)
    rename_table(:event_lecturer_associations, :event_tutor_associations)
  end
end
