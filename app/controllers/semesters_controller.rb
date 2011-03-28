class SemestersController < ApplicationController
  def index
    @semesters = Semester.all
  end
  
  def show
    @semester = Semester.find(params[:id])
  end
end
