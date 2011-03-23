class AddEvaIdToSemestersAndRenameEvaMarkerOnTutors < ActiveRecord::Migration
  def self.up
    add_column :semesters, :eva_marker, :string
    rename_column :tutors, :eva_marker, :eva_id
  end

  def self.down
    rename_column :tutors, :eva_id, :eva_marker
    remove_column :semesters, :eva_marker
  end
end
