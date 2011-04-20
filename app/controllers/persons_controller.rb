class PersonsController < ApplicationController

  before_filter :find_person, :only => [:show, :delete, :destroy, :edit, :update]


  def index
    @persons = Person.order('surname DESC').all
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
      redirect_to persons_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    @person.destroy
    redirect_to persons_path
  end

  def delete

  end

  protected

  def find_person
    @person = Person.find(params[:id])
  end

end