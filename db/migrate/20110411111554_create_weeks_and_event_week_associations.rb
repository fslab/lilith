class CreateWeeksAndEventWeekAssociations < ActiveRecord::Migration
  def self.up
    create_table :weeks, :id => false do |t|
      t.integer :year
      t.integer :index
      t.timestamps
    end

    add_column :weeks, :id, :uuid

    execute %{ALTER TABLE "weeks" ADD PRIMARY KEY (id)}

    create_table :event_week_associations, :id => false do |t|
      t.timestamps
    end

    add_column :event_week_associations, :id, :uuid
    add_column :event_week_associations, :event_id, :uuid
    add_column :event_week_associations, :week_id, :uuid

    execute %{ALTER TABLE "event_week_associations" ADD PRIMARY KEY (id)}
  end

  def self.down
    drop_table :event_week_associations
    drop_table :weeks
  end
end
