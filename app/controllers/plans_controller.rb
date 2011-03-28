class PlansController < ApplicationController
  def show
    @plan = Plan.find(params[:id])
  end
end
