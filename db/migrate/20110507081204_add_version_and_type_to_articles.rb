class AddVersionAndTypeToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :version, :string, :default => nil
    add_column :articles, :type, :string

    add_index :articles, :version, :unique => true
  end

  def self.down
    remove_index :articles, :version

    remove_column :articles, :type
    remove_column :articles, :version
  end
end
