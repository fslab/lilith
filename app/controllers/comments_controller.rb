class CommentsController < ApplicationController
  before_filter :find_course

  def new
    @comment = @course.comments.new
  end

  def create
    @comment = @course.comments.new

    if @comment.update_attributes(params[:comment].merge(author_id: current_user.id))
      redirect_to course_path(@course)
    else
      render :action => :new
    end
  end

  protected

  def find_course
    @course = Course.find(params[:course_id])
  end
end