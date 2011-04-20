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

require 'machinist/active_record'

# Add your blueprints here.
#
# e.g.
#   Post.blueprint do
#     title { "Post #{sn}" }
#     body  { "Lorem ipsum..." }
#   end

Semester.blueprint do
  start_year { 2011 }
  season     { :summer }
  start_week { Aef::Week.new(2011, 50) }
  end_week   { Aef::Week.new(2012, 12) }
end

Person.blueprint do
  title      { 'Lord' }
  forename   { 'Omar' }
  middlename { 'Kayyam' }
  surname    { 'Ravenhurst' }
  eva_id     { 'ravenhurst' }
end

Schedule.blueprint do
  created_at { Date.parse('2011-03-02') }
end

StudyUnit.blueprint do
  semester { Semester.make! }
  program  { 'Master OTU' }
  position { 2 }
end

Course.blueprint do
  study_unit { StudyUnit.make! }
  name       { 'Humanoide Metaphysik I' }
end

Group.blueprint do
  course { Course.make! }
  name   { 3 }
end

Event.blueprint do
  schedule    { Schedule.make! }
  course      { Course.make! }
  first_start { Date.parse('2011-05-23 17:00')}
  first_end   { Date.parse('2011-05-23 17:45')}
end

Week.blueprint do
  index { 15 }
  year  { 2011 }
end