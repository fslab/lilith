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
  start_week { Lilith::Week.new(2011, 50) }
  end_week   { Lilith::Week.new(2012, 12) }
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