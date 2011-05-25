# encoding: UTF-8
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

# A person, currently mostly people who organize events
class Person < ActiveRecord::Base
  include Lilith::UUIDHelper

  has_many :event_associations,
           :class_name => 'EventLecturerAssociation',
           :dependent => :destroy
  has_many :events, :through => :event_associations

  # default order for people
  default_scope order('eva_id DESC, forename DESC, surname DESC')

  def self.matched
    where('eva_id = surname')
  end

  def self.matchless
    where('surname IS NULL')
  end

  # The full name of the person if available, otherwise the eva_id
  def name
    if surname
      name = surname

      if forename
        if middlename
          name = "#{forename} #{middlename} #{name}"
        else
          name = "#{forename} #{name}"
        end
      end

      name = "#{title} #{name}" if title

      name
    else
      eva_id
    end
  end
end
