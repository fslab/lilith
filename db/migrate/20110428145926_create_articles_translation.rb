class CreateArticlesTranslation < ActiveRecord::Migration

  def self.up
    create_table:articles_translations, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type(:for_migration)
      t.references :articles
      t.string :locale

      t.string :name
      t.string :abstract
      t.string :body

      t.timestamps
    end

    add_index :articles_translations, [:id, :locale], :unique => true
  end

  def self.down
    drop_table :articles_translations
  end
end
