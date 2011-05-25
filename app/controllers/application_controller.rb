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

  helper_method :current_user

  before_filter :set_locale
  before_filter :set_timezone
  after_filter :set_mime_type

  protected

  def current_user_session
    @current_user_session ||= User::Session.find
  end

  def current_user
    @current_user ||= current_user_session.try(:record)
  end

  # Authenticates an administrator by configured credentials
  # Outside of development environment, this will raise an exception if no credentials are configured
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

  # Determines the response locale for the request
  def set_locale
    unless params[:locale]
      # If no locale is given via URL, it is determined through HTTP Accept-Language and I18n.default_locale
      quality_table = []

      # Generate a table which maps each available locale with a quality, locales can possibly be included multiple times
      I18n.available_locales.map{|locale| [locale, Rack::Acceptable::LanguageTag.parse(locale.to_s)] }.each do |locale, language_tag|
        Rack::Acceptable::Request.new(request.env).acceptable_language_ranges.each do |language_range, quality|
          if language_tag.matched_by_extended_range?(language_range)
            quality_table << {
              :locale => locale,
              :quality => quality
            }
          end
        end
      end

      # Sort the table so that the last element is the one with the highest quality
      quality_table.sort!{|a,b| a[:quality] <=> b[:quality] }

      # Determine the highest quality
      highest_quality = quality_table.last.try(:[], :quality)

      # Select all entries which have the highest quality
      winners = quality_table.select{|element| element[:quality] == highest_quality}

      # If the default locale is included or if no winners are found, choose the default locale,
      # otherwise choose the first winner in winners
      if winners.find{|element| element[:locale] == I18n.default_locale} or winners.empty?
        redirect_to :locale => I18n.default_locale
      else
        redirect_to :locale => winners.first[:locale]
      end
    else
      I18n.locale = params[:locale]
    end

    response.headers['Content-Language'] = I18n.locale.to_s
  end

  # Sets the timezone for the dates in the response
  def set_timezone
    Time.zone = 'Berlin'
  end

  # Sets default options which will be part of every URL unless overridden
  def default_url_options(options = {})
    {:locale => I18n.locale}
  end

  # Determines the Internet media type/MIME-type for the response
  def set_mime_type
    if response.content_type == 'text/html' and
       not request.headers['User-Agent'].include?('MSIE')
        response.content_type = 'application/xhtml+xml'
    end
  end
end
