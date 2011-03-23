class RootController < ApplicationController
  def show
    redirect_to(semesters_path)
  end
end