class CreateCategoriesAndCategoryEventAssociations < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.string :eva_id
    end

    create_table :category_event_associations do |t|
      t.belongs_to :category
      t.belongs_to :event
    end
  end

  def self.down
    drop_table :category_event_associations
    drop_table :categories
  end
end
