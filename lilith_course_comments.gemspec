# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'lilith_course_comments'
  s.version = '0.0.1'
  s.authors = ["Alexander E. Fischer"]
  s.date = '2011-10-09'
  s.description = 'An plugin for Lilith which allows commenting on courses'
  s.summary = 'A plugin for Lilith which allows commenting on courses'
  s.email = 'aef@raxys.net'
  s.files = %w{lib/lilith_course_comments.rb app/views/courses/index.html.haml app/views/courses/show.html.haml app/views/comments/new.html.haml app/models/comment.rb app/models/course.rb app/models/user.rb app/controllers/courses_controller.rb app/controllers/comments_controller.rb config/routes.rb config/navigation.rb}

end
