class PeopleController < ApplicationController

  before_filter :authenticate
  before_filter :find_person, :only => [:show, :delete, :destroy, :edit, :update]


  def index
    @people = Person.order('surname DESC').all
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
