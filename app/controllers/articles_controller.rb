class ArticlesController < ApplicationController
  
  def index
    @articles = Article.order('published_at ASC').all
  end
  
  def show
    @article = Article.find(params[:id])
  end

end
