require 'machinist/active_record'

# Add your blueprints here.
#
# e.g.
#   Post.blueprint do
#     title { "Post #{sn}" }
#     body  { "Lorem ipsum..." }
#   end

Semester.blueprint do
  begin_year { Date.parse('2011-01-01') }
  season     { :summer }
end