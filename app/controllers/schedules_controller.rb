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

class SchedulesController < ApplicationController
  def index
    redirect_to schedule_path(
      params[:schedule_id],
      :format     => params[:format],
      :course_ids => params[:course_ids],
      :group_ids  => params[:group_ids]
    )
  end

  def show
    Schedule.find(params[:id])

    @events = Set.new

    elements = Set.new
    elements += Group.find_all_by_id(params[:group_ids])
    elements += Course.find_all_by_id(params[:course_ids])

    elements.each do |element|
      @events += element.events
    end

    respond_to do |format|
      format.ical do
        calendar = Icalendar::Calendar.new

        @events.each do |event|
          calendar.add(event.to_ical)
        end

        render :text => calendar.to_ical
      end
      format.xml { render :xml => @events.to_a }
    end
  end
end
