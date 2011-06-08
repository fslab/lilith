class CreatePeopleScraperMappings < ActiveRecord::Migration
  def self.up
    create_table :people_scraper_mappings, :id => false do |t|
      t.column :id, Lilith.db_primary_key_type
      t.string :surname
      t.string :eva_id
      t.boolean :reject
      t.timestamps
    end
  end

  def self.down
    drop_table :people_scraper_mappings
  end
end