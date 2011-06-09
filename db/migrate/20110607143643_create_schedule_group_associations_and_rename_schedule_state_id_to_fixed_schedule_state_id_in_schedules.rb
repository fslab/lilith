class CreateScheduleGroupAssociationsAndRenameScheduleStateIdToFixedScheduleStateIdInSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedule_group_associations, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type
      t.column :schedule_id, Lilith.db_reference_type, :null => false
      t.column :group_id, Lilith.db_reference_type, :null => false
      t.timestamps :null => false
    end

    add_index :schedule_group_associations, :schedule_id
    add_index :schedule_group_associations, :group_id
    add_index :schedule_group_associations, [:schedule_id, :group_id], :unique => true

    add_foreign_key :schedule_group_associations, :schedules, :dependent => :restrict
    add_foreign_key :schedule_group_associations, :groups, :dependent => :restrict

    rename_column :schedules, :schedule_state_id, :fixed_schedule_state_id
  end

  def self.down
    rename_column :schedules, :fixed_schedule_state_id, :schedule_state_id

    remove_foreign_key :schedule_group_associations, :groups
    remove_foreign_key :schedule_group_associations, :schedules

    remove_index :schedule_group_associations, [:schedule_id, :group_id]
    remove_index :schedule_group_associations, :group_id
    remove_index :schedule_group_associations, :schedule_id

    drop_table :schedule_group_associations
  end
end
