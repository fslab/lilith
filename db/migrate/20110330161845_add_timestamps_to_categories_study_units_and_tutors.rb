=begin
Copyright Alexander E. Fischer <aef@raxys.net>, 2011

This file is part of Lilith.

Lilith is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Lilith is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Lilith.  If not, see <http://www.gnu.org/licenses/>.
=end

class AddTimestampsToCategoriesStudyUnitsAndTutors < ActiveRecord::Migration
  def self.up
    add_column :categories, :created_at, :datetime
    add_column :categories, :updated_at, :datetime

    add_column :study_units, :created_at, :datetime
    add_column :study_units, :updated_at, :datetime

    add_column :tutors, :created_at, :datetime
    add_column :tutors, :updated_at, :datetime
  end

  def self.down
    remove_column :tutors, :created_at
    remove_column :tutors, :updated_at
    
    remove_column :study_units, :created_at
    remove_column :study_units, :updated_at

    remove_column :categories, :created_at
    remove_column :categories, :updated_at
  end
end
