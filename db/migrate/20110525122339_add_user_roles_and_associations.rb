class AddUserRolesAndAssociations < ActiveRecord::Migration
  def self.up
    create_table :user_roles, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type
      t.string :name
      t.timestamps
    end

    add_index :user_roles, :name, :unique => true

    create_table :user_role_associations, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type
      t.column :user_id, Lilith.db_reference_type
      t.column :role_id, Lilith.db_reference_type
      t.timestamps
    end

    add_index :user_role_associations, [:user_id, :role_id], :unique => true
    add_index :user_role_associations, :user_id
    add_index :user_role_associations, :role_id

    add_foreign_key :user_role_associations, :users, :dependent => :restrict
    add_foreign_key :user_role_associations, :user_roles, :column => :role_id, :dependent => :restrict
  end

  def self.down
    remove_foreign_key :user_role_associations, :users
    remove_foreign_key :user_role_associations, :column => :role_id

    remove_index :user_role_associations, :role_id
    remove_index :user_role_associations, :user_id
    remove_index :user_role_associations, [:user_id, :role_id]

    drop_table :user_role_associations

    remove_index :user_roles, :name

    drop_table :user_roles
  end
end
