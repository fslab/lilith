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
  before_filter :find_user
  before_filter :build_or_find_schedule, :except => [:index, :new, :create, :destroy]
  before_filter :find_schedule, :only => [:destroy]
  
  def index
    if not @user
      if current_user
        redirect_to user_schedules_path(:user_id => current_user.login)
      else
        redirect_to new_schedule_path
      end
    elsif current_user == @user
      @schedules = @user.schedules.permanent
      @temporary_schedules = @user.schedules.temporary
    else
      @schedules = @user.schedules.permanent.public
    end
  end

  def show
    authorize! :read, @schedule

    disposition = (params[:disposition] || params[:d]) == 'attachment' ? :attachment : :inline
    
    base_name  = [@schedule.updated_at.iso8601, 'lilith']
    base_name += [@user.login, @schedule.name] if @schedule.permanent?
    base_name  = base_name.join('_')

    respond_to do |format|
      format.html
      format.ics do
        set_disposition(disposition, base_name + '.ics')
        render :text => @schedule.to_ical
      end
      format.xml do
        set_disposition(disposition, base_name + '.xml')
        render :xml => @schedule.events.to_a
      end
    end
  end

  def new
    @semester = Semester.latest
    @schedule_states = @semester.schedule_states.order('created_at DESC')
    @study_units = @semester.study_units.order('program ASC, position ASC')

    @schedule = Schedule.new
  end

  def create
    @semester = Semester.latest
    @schedule_states = @semester.schedule_states.order('created_at DESC')
    @study_units = @semester.study_units.order('program ASC, position ASC')

    if current_user
      ActiveRecord::Base.transaction do
        params[:schedule][:name]        = nil if params[:schedule][:name].blank?
        params[:schedule][:description] = nil if params[:schedule][:description].blank?

        if params[:schedule][:fixed_schedule_state_id] == 'latest'
          params[:schedule][:fixed_schedule_state_id] = nil
        end

        # Create a new one
        @schedule = current_user.schedules.create(params[:schedule])

        # Build associations
        @schedule.courses += Course.find(params[:schedule][:course_ids] || [])
        @schedule.groups  += Group.find(params[:schedule][:group_ids] || [])
      end

      if @schedule.valid?
        redirect_to schedule_path(@schedule)
      else
        render :action => :new
      end
    else
      redirect_to schedule_path(compress_params(params).merge(:id => 'unsaved'))
    end
  end

# TODO: Not yet implemented
#  def edit
#    render :action => :new
#  end

  def update
    authorize! :update, @schedule

    show_path = schedule_path(@schedule)

    if @schedule.update_attributes(params[:schedule])
      redirect_to schedule_path(@schedule)
    else
      if params[:source_action] == 'show'
        render :action => :show
      else
        render :action => :new
      end
    end
  end

  def destroy
    authorize! :destroy, @schedule

    @schedule.destroy

    redirect_to user_schedules_path(@schedule.user.login)
  end

  protected

  # If the given id is 'unsaved' build a non-persisted schedule from the given
  # params, otherwise load matching id from DB
  def build_or_find_schedule
    if params[:id] == 'unsaved'
      @schedule = Schedule.new

      decompressed_params = decompress_params(params)

      fixed_schedule_state_id = decompressed_params[:fixed_schedule_state_id]

      if fixed_schedule_state_id and fixed_schedule_state_id != 'latest'
        @schedule.fixed_schedule_state = ScheduleState.find(params[:fixed_schedule_state_id])
      end
      
      @schedule.courses = Course.find(decompressed_params[:course_ids].to_a)
      @schedule.groups  = Group.find(decompressed_params[:group_ids].to_a)
      @schedule.updated_at = Time.now
    else
      find_schedule
    end
  end

  # Finds a schedule by UUID or by user login and schedule name
  def find_schedule
    uuid = UUIDTools::UUID.parse(params[:id])
    @schedule = Schedule.find(uuid.to_s)
  rescue ArgumentError
    @schedule = @user.schedules.find_by_name(params[:id]) if @user
  end

  # Finds a user either by UUID or by its login
  def find_user
    if params[:user_id]
      uuid = UUIDTools::UUID.parse(params[:user_id])
      @user = User.find(uuid.to_s)
    end
  rescue ArgumentError
    @user = User.find_by_login(params[:user_id])
  end

  # Heavily shorten the params to support setups with limited maximum URL lengths
  # Also stores an element count to verify full URL transmission for error detection
  def compress_params(uncompressed_params)
    elements = {
      :c => (uncompressed_params[:schedule][:course_ids] || []).to_set,
      :g => (uncompressed_params[:schedule][:group_ids] || []).to_set
    }

    element_count = 0

    elements.each do |key, value|
      element_count += value.length
      
      elements[key] = value.map{|element| UUIDTools::UUID.parse(element).hexdigest }.join('|')
    end

    elements.merge(
      :s => uncompressed_params[:schedule][:fixed_schedule_state_id],
      :d => uncompressed_params[:schedule][:disposition],
      :e => element_count
    )
  end

  # Recovers the original params from a compressed ones
  # The element count is checked to match the encoded one to detect errors
  def decompress_params(compressed_params)
    elements = {
      :course_ids => compressed_params[:c].try(:split, '|').try(:to_set) || Set.new,
      :group_ids  => compressed_params[:g].try(:split, '|').try(:to_set) || Set.new
    }

    element_count = 0

    elements.each do |key, value|
      value.map!{|element| UUIDTools::UUID.parse_hexdigest(element).to_s }

      element_count += value.length
    end

    if element_count != expected_count = compressed_params[:e].to_i
      raise "Params were corrupted. Expected #{expected_count}, got #{element_count}"
    end

    {
      :fixed_schedule_state_id => compressed_params[:s],
      :disposition => compressed_params[:d]
    }.merge(elements)
  end

  # Allows to set the Content-Disposition header to allow
  # users to decide wheter they want to open a file in
  # their browser or download it
  def set_disposition(type, filename)
    response.headers['Content-Disposition'] = %{#{type}; filename="#{filename}"}
  end
end
