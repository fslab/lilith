require 'spec_helper'

describe ArticlesController do
  describe "GET index" do
    
    it "assigns @articles" do
      article = Article.make!
      get :index, :locale => 'en'
      assigns(:articles).should == [article]
    end
    
    
    it "renders the index template" do
      get :index, :locale => 'en'
      response.should render_template('index')
    end
  
  end
end
