Lilith::NAVIGATION_PROCS = []
Lilith::NAVIGATION_PROCS << lambda do |items|
  items << { key: :dashboard, name: t('dashboard.menu_name'), url: dashboard_path }
  items << { key: :schedules, name: t('schedules.menu_name'), url: schedules_path }
end
