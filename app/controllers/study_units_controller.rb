class StudyUnitsController < ApplicationController
  def index
    @semester = Semester.find(params[:semester_id])
    @study_units = @semester.study_units
  end
  
  def show
    @study_unit = StudyUnit.find(params[:id])
  end
end
