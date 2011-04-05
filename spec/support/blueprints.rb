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