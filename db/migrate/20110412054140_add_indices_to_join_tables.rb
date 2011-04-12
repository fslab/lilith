class AddIndicesToJoinTables < ActiveRecord::Migration
  def self.up
    add_index :category_event_associations, :category_id
    add_index :category_event_associations, :event_id

    add_index :event_week_associations, :event_id
    add_index :event_week_associations, :week_id

    add_index :event_tutor_associations, :event_id
    add_index :event_tutor_associations, :tutor_id

    add_index :event_group_associations, :event_id
    add_index :event_group_associations, :group_id
  end

  def self.down
    remove_index :event_week_associations
    remove_index :event_week_associations

    remove_index :event_tutor_associations
    remove_index :event_tutor_associations

    remove_index :event_group_associations
    remove_index :event_group_associations

    remove_index :category_event_associations
    remove_index :category_event_associations
  end
end
