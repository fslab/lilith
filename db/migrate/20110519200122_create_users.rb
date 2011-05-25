class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type(:for_migration)
      t.string :login
      t.string :persistence_token
    end
  end

  def self.down
    drop_table :users
  end
end
