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

class TutorsController < ApplicationController
  # GET /tutors
  # GET /tutors.xml
  def index
    @tutors = Tutor.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tutors }
    end
  end

  # GET /tutors/1
  # GET /tutors/1.xml
  def show
    @tutor = Tutor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tutor }
    end
  end

  # GET /tutors/new
  # GET /tutors/new.xml
  def new
    @tutor = Tutor.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tutor }
    end
  end

  # GET /tutors/1/edit
  def edit
    @tutor = Tutor.find(params[:id])
  end

  # POST /tutors
  # POST /tutors.xml
  def create
    @tutor = Tutor.new(params[:tutor])

    respond_to do |format|
      if @tutor.save
        format.html { redirect_to(@tutor, :notice => 'Tutor was successfully created.') }
        format.xml  { render :xml => @tutor, :status => :created, :location => @tutor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tutor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tutors/1
  # PUT /tutors/1.xml
  def update
    @tutor = Tutor.find(params[:id])

    respond_to do |format|
      if @tutor.update_attributes(params[:tutor])
        format.html { redirect_to(@tutor, :notice => 'Tutor was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tutor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tutors/1
  # DELETE /tutors/1.xml
  def destroy
    @tutor = Tutor.find(params[:id])
    @tutor.destroy

    respond_to do |format|
      format.html { redirect_to(tutors_url) }
      format.xml  { head :ok }
    end
  end
end
