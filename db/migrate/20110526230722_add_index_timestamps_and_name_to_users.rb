class AddIndexTimestampsAndNameToUsers < ActiveRecord::Migration
  def self.up
    add_index :users, :login, :unique => true

    add_column :users, :created_at, :datetime
    add_column :users, :updated_at, :datetime
    add_column :users, :name, :string
  end

  def self.down
    remove_column :users, :name
    remove_column :users, :updated_at
    remove_column :users, :created_at

    remove_index :users, :login
  end
end
