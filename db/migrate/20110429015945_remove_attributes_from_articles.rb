class RemoveAttributesFromArticles < ActiveRecord::Migration
  def self.up
    remove_column :articles, :name
    remove_column :articles, :abstract
    remove_column :articles, :body
  end

  def self.down
    remove_column :articles, :body, :text
    remove_column :articles, :abstract, :text
    remove_column :articles, :name, :string
  end
end
