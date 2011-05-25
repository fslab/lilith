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

# Manages lifecycle of Person models
class PeopleController < ApplicationController

  before_filter :authenticate
  before_filter :find_person, :only => [:show, :delete, :destroy, :edit, :update]


  def index
    @people = Person.order('surname DESC').all

    @people_matched = Person.matched
    @people_matchless = Person.matchless
  end

  def show

  end

  def new
    @person = Person.new
  end

  def edit


  end

  def update
    if @person.update_attributes(params[:person])
      redirect_to people_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    @person.destroy
    redirect_to people_path
  end

  def delete

  end

  protected

  def find_person
    @person = Person.find(params[:id])
  end

end
