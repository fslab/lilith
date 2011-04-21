class AdminController < ApplicationController

  # admin:test
  USERNAME, PASSWORD = "admin", "098f6bcd4621d373cade4e832627b4f6"


  before_filter :authenticate, :only => [:delete, :destroy, :edit, :update]

  private

  def authenticate
    if Rails.env == 'production'
      authenticate_or_request_with_http_basic do |username, password|
        username == USERNAME && Digest::MD5.hexdigest(password) == PASSWORD
      end
    end
  end
end