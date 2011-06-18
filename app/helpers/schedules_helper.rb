module SchedulesHelper
  # Overloads the normal named route to decide between permanent and temporary schedule routes
  def schedule_path(*arguments)
    if arguments.first.is_a?(Schedule)
      raise ArgumentError, "wrong number of arguments (#{arguments.count} for 1..2)" if arguments.count > 2
      schedule = arguments[0]
      options = arguments[1] || {}

      if schedule.persisted? and schedule.name
        user_schedule_path(options.merge(:id => schedule.name, :user_id => schedule.user.login))
      else
        super(options.merge(:id => schedule.id))
      end
    else
      super(*arguments)
    end
  end

  # Overloads the normal named route to decide between permanent and temporary schedule routes
  def edit_schedule_path(*arguments)
    if arguments.first.is_a?(Schedule)
      raise ArgumentError, "wrong number of arguments (#{arguments.count} for 1..2)" if arguments.count > 2
      schedule = arguments[0]
      options = arguments[1] || {}

      if schedule.persisted? and schedule.name
        edit_user_schedule_path(options.merge(:id => schedule.name, :user_id => schedule.user.login))
      else
        super(options.merge(:id => schedule.id))
      end
    else
      super(*arguments)
    end
  end
end