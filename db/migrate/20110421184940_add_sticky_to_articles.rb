class AddStickyToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :sticky, :boolean
  end

  def self.down
    remove_column :articles, :sticky
  end
end
