class CreateComments < ActiveRecord::Migration
  def up
    create_table :comments, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type
      t.column :author_id, Lilith.db_reference_type, :null => false
      t.column :course_id, Lilith.db_reference_type, :null => false
      t.string :name
      t.text :body
      t.timestamps
    end

    add_index :comments, :author_id
    add_index :comments, :course_id

    add_foreign_key :comments, :users, :column => :author_id, :dependent => :restrict
    add_foreign_key :comments, :courses, :dependent => :restrict
  end
end
