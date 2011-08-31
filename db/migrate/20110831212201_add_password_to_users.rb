class AddPasswordToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :password_hash, :string
    add_column :users, :password_salt, :string
  end

  def self.down
    remove_column :users, :password_salt
    remove_column :users, :password_hash
  end
end
