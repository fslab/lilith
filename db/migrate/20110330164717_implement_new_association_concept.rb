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

class ImplementNewAssociationConcept < ActiveRecord::Migration
  def self.up
    add_column :courses, :study_unit_id, :integer
    remove_column :courses, :plan_id

    add_column :events, :plan_id, :integer
  end

  def self.down
    remove_column :events, :plan_id

    add_column :courses, :plan_id, :integer
    remove_column :courses, :study_unit_id
  end
end