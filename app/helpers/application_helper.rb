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

module ApplicationHelper
  def set_body_id(body_id)
    @body_id = body_id
  end

  def body_id
    @body_id ||= 'top'
  end
  
  def textilize(input)
    RedCloth.new(input.to_s).to_html.html_safe
  end

  def current_url(new_params = {})
    url_for(params.merge(new_params).merge(:only_path => false))
  end

  def current_path(new_params = {})
    url_for(params.merge(new_params).merge(:only_path => true))
  end
end
