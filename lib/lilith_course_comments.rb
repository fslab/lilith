module LilithCourseComments
  class Engine < Rails::Engine
    initializer :add_navigation_configuration do |app|
      load (paths.path + 'config' + 'navigation.rb').to_s
    end
  end
end
