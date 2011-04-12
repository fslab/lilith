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
  before_filter :set_semester

  def index
    redirect_to semester_schedule_path(
      @semester.token,
      params[:schedule_id],
      :format     => params[:format],
      :course_ids => params[:course_ids],
      :group_ids  => params[:group_ids]
    )
  end

  def show
    @schedule = Schedule.find(params[:id])

    @events = Set.new

    elements = Set.new
    elements += Group.find_all_by_id(params[:group_ids])
    elements += Course.find_all_by_id(params[:course_ids])

    elements.each do |element|
      @events += element.events.exclusive(@schedule)
    end

    respond_to do |format|
      format.ical do
        calendar = RiCal::Component::Calendar.new

        @events.each do |event|
          calendar.add_subcomponent(event.to_ical)
        end

        render :text => calendar
      end
      format.xml { render :xml => @events.to_a }
    end
  end

  def new
    @schedules   = @semester.schedules.order('created_at DESC')
    @study_units = @semester.study_units.order('program ASC, position ASC')
  end

  protected

  def set_semester
    @semester = Semester.find(params[:semester_id])
  end
end
