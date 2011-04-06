class MoveSchedulesBelowSemesters < ActiveRecord::Migration
  def self.up
    remove_column :schedules, :study_unit_id
    add_column :schedules, :semester_id, :uuid
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
