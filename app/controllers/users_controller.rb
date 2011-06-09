class UsersController < ApplicationController
  before_filter :find_user

  def show

  end

  protected

  def find_user
    uuid = UUIDTools::UUID.parse(params[:id])
    @user = User.find(uuid.to_s)
  rescue ArgumentError
    @user = User.find_by_login(params[:id])
  end
end