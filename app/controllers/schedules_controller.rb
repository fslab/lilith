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

# Controller responsible for custom schedule generation
class SchedulesController < ApplicationController
  before_filter :set_semester

  def index
    if @semester
      redirect_to semester_schedule_path(
        @semester.token,
        params[:schedule_id],
        :format     => params[:format] || params[:f],
        :course_ids => params[:course_ids],
        :group_ids  => params[:group_ids],
        # Short versions for params above (because of URL length limits)
        :c          => params[:c], # Group
        :g          => params[:g]  # Course
      )
    else
      redirect_to new_semester_schedule_path(Semester.latest.token)
    end
  end

  def show
    # Merge params given as short versions into the regular params
    course_ids = uuid_set(params[:course_ids]) + uuid_set(params[:c])
    group_ids  = uuid_set(params[:group_ids]) + uuid_set(params[:g])

    @schedule = Schedule.find(params[:id])

    @events = Set.new

    elements = Set.new
    elements += Group.where(:id => group_ids.map(&:to_s))
    elements += Course.where(:id => course_ids.map(&:to_s))

    elements.each do |element|
      @events += element.events.exclusive(@schedule)
    end

    respond_to do |format|
      format.ics do
        calendar = RiCal::Component::Calendar.new
        calendar.prodid = "-//fslab.de/NONSGML Lilith #{Lilith::VERSION}/EN"

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
  rescue
    @semester = nil
  end

  def uuid_set(set)
    set = set || Set.new
    set.map{|element| Lilith::UUIDHelper.to_uuid(element) }.to_set
  end
end
