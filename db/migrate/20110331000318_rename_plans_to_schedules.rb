class RenamePlansToSchedules < ActiveRecord::Migration
  def self.up
    rename_table :plans, :schedules
    rename_column :events, :plan_id, :schedule_id
  end

  def self.down
    rename_column :events, :schedule_id, :plan_id 
    rename_table :schedules, :plans
  end
end
