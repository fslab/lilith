class CreateArticles < ActiveRecord::Migration

  PRIMARY_KEY = 'UUID PRIMARY KEY'
  REFERENCE   = 'UUID'

  def self.up
    create_table :articles, :id => false do |t|
      t.string :name
      t.datetime :published_at
      t.text :abstract
      t.text :body
      t.timestamps
    end    
    
    add_column :articles, :id, PRIMARY_KEY
  
  end
    
  def self.down
    drop_table :articles
  end

end
