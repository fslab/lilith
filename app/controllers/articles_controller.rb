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

# Manages lifecycle of Article models
class ArticlesController < ApplicationController

  before_filter :authenticate, :except => :show
  before_filter :find_article, :except => [:index, :create, :new]

  # List articles
  def index
    @unpublished_sticky_articles = Article.unpublished.sticky
    @unpublished_non_sticky_articles = Article.unpublished.non_sticky

    @published_sticky_articles = Article.published.sticky
    @published_non_sticky_articles = Article.published.non_sticky
  end

  # Display an article
  def show
        
  end

  # Mask for article modification
  def edit
  
  end

  # Execute an article update
  def update
    params[:article][:published] = params[:article][:published] ? true : false

    if @article.update_attributes(params[:article])
      redirect_to articles_path
    else
      render :action => 'edit'
    end
  end  

  # Mask for article deletion
  def delete

  end

  # Execute an article deletion
  def destroy
    @article.destroy
    redirect_to articles_path
  end

  # Mask for article creation
  def new
    @article = Article.new
  end

  # Execute an article creation
  def create
    params[:article][:published] = params[:article][:published] ? true : false

    @article = Article.new(params[:article])
    
    if @article.save
      redirect_to articles_path
    else
      render :action => 'new'    
    end
  end

  protected

  # Finds an article by ID from URL
  def find_article
    @article = Article.find(params[:id])
  end    

end
