class CreateArticleTranslations < ActiveRecord::Migration

  def self.up
    create_table:article_translations, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type(:for_migration)
      t.column :article_id, Lilith.db_reference_type
      t.string :locale

      t.string :name
      t.string :abstract
      t.string :body

      t.timestamps
    end

    add_index :article_translations, [:article_id, :locale], :unique => true
  end

  def self.down
    drop_table :article_translations
  end
end
