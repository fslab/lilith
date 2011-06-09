class SessionController < ApplicationController
  # TODO: Handle LDAP connection error
  rescue_from(ActiveLdap::ConnectionError) do
    flash[:notify] = 'Connection to LDAP is currently unavailable'
    redirect_to new_session_path
  end

  def show
    redirect_to new_session_path
  end

  def new
    @user_session = User::Session.new
  end

  def delete
    if current_user
      @user_session = User::Session.find
    else
      redirect_to new_session_path
    end
  end

  def create
    @user_session = User::Session.create(params[:user_session])

    if @user_session.valid?
      redirect_to root_path
    else
      render :action => :new
    end
  end

  def destroy
    @user_session = User::Session.find
    @user_session.destroy

    redirect_to root_path
  end
end