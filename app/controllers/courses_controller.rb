class CoursesController < ApplicationController
  def index
    @semester = Semester.latest
    @courses_by_study_units = {}

    @semester.study_units.each do |study_unit|
      @courses_by_study_units[study_unit] = study_unit.courses.order('name')
    end
  end

  def show
    @course = Course.find(params[:id])
  end
end