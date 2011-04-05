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
end

Tutor.blueprint do
  title      { 'Lord' }
  forename   { 'Omar' }
  middlename { 'Kayyam' }
  surname    { 'Ravenhurst' }
  eva_id     { 'ravenhurst' }
end

Course.blueprint do
  name { 'Humanoide Metaphysik I' }
end

Group.blueprint do
  course { Course.make! }
  name   { 3 }
end

Event.blueprint do
  course      { Course.make! }
  first_start { Date.parse('2011-05-23 17:00')}
  first_end   { Date.parse('2011-05-23 17:45')}
end