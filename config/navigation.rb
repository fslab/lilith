Lilith::NAVIGATION_PROCS << lambda do |items|
  items << { key: :courses, name: t('courses.menu_name'), url: courses_path }
end
