class ArticlesController < AdminController

  before_filter :find_article, :only => [:show, :delete, :destroy, :edit, :update]
  
  def index
    @articles = Article.order('published_at ASC').all
  end
  
  def show
        
  end
  
  def edit
  
  end

  def update
    if @article.update_attributes(params[:article])
      redirect_to articles_path
    else
      render :action => 'edit'
    end
    
    
  end  

  def delete
        
  end
  
  def destroy
    @article.destroy
    redirect_to articles_path
  end
  
  def new
    @article = Article.new
  end
  
  def create 
    @article = Article.new(params[:article])
    
    if @article.save
      redirect_to articles_path
    else
      render :action => 'new'    
    end
  end

  protected

  def find_article
    @article = Article.find(params[:id])
  end    

end
