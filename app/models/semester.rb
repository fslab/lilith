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
# One of two periods in a year in which study units occur
class Semester < ActiveRecord::Base
  include Lilith::UUIDHelper
  
  has_many :study_units, :dependent => :destroy
  
  def name
    case season.to_sym
    when :winter
      "WS #{start_year}/#{start_year + 1}"
    when :summer
      "SS #{start_year}"
    end
  end
end
