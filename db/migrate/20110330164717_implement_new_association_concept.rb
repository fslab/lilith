class ImplementNewAssociationConcept < ActiveRecord::Migration
  def self.up
    add_column :courses, :study_unit_id, :integer
    remove_column :courses, :plan_id

    add_column :events, :plan_id, :integer
  end

  def self.down
    remove_column :events, :plan_id

    add_column :courses, :plan_id, :integer
    remove_column :courses, :study_unit_id
  end
end
