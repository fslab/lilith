=begin encoding: UTF-8
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

class Week < ActiveRecord::Base
  include Lilith::UUIDHelper

  has_many :event_associations,
           :class_name => 'EventWeekAssociation',
           :dependent => :destroy
  has_many :events, :through => :event_associations

  def to_week
    Lilith::Week.new(year, index)
  end
end