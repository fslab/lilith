# encoding: UTF-8
=begin
Copyright Alexander E. Fischer <aef@raxys.net>, 2011

This file is part of Lilith.

Lilith is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Lilith is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Lilith.  If not, see <http://www.gnu.org/licenses/>.
=end

# The parent class of most controllers in Lilith
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  before_filter :set_timezone
  after_filter :set_mime_type

  protected

  def authenticate
    unless Rails.configuration.admin_username.blank? or
           Rails.configuration.admin_password.blank?
      authenticate_or_request_with_http_basic do |username, password|
        username == Rails.configuration.admin_username && password == Rails.configuration.admin_password
      end
    else
      unless Rails.env == 'development'
        raise 'admin_username and admin_password are required to be configured outside development mode'
      end
    end
  end

  def set_locale
    unless params[:locale]
      redirect_to :locale => I18n.default_locale
    else
      I18n.locale = params[:locale]
    end

    response.headers['Content-Language'] = I18n.locale.to_s
  end

  def set_timezone
    Time.zone = 'Berlin'
  end

  def default_url_options(options = {})
    {:locale => I18n.locale}
  end

  def set_mime_type
    if response.content_type == 'text/html' and
       not request.headers['User-Agent'].include?('MSIE')
        response.content_type = 'application/xhtml+xml'
    end
  end
end
