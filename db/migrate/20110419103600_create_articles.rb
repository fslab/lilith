class CreateArticles < ActiveRecord::Migration

  def self.up
    create_table :articles, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type(:for_migration)
      t.string :name
      t.datetime :published_at
      t.text :abstract
      t.text :body
      t.timestamps
    end    

  end
    
  def self.down
    drop_table :articles
  end

end
