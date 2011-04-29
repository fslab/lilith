class ArticlesController < ApplicationController

  before_filter :authenticate, :except => :show
  before_filter :find_article, :except => [:index, :create, :new]

  # List articles
  def index
    @articles = Article.order('published_at ASC').all
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
