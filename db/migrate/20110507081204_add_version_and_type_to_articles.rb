class AddVersionAndTypeToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :version, :string
    add_column :articles, :type, :string
  end

  def self.down
    remove_column :articles, :type
    remove_column :articles, :version
  end
end
