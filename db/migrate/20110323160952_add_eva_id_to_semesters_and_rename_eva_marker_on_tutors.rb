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

class AddEvaIdToSemestersAndRenameEvaMarkerOnTutors < ActiveRecord::Migration
  def self.up
    add_column :semesters, :eva_marker, :string
    rename_column :tutors, :eva_marker, :eva_id
  end

  def self.down
    rename_column :tutors, :eva_id, :eva_marker
    remove_column :semesters, :eva_marker
  end
end
