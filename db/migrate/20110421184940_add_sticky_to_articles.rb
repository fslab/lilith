class AddStickyToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :sticky, :boolean, :default => false
  end

  def self.down
    remove_column :articles, :sticky
  end
end
