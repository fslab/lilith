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

require 'spec_helper'

describe ArticlesController do
  def basic_auth(user, password)
    credentials = ActionController::HttpAuthentication::Basic.encode_credentials user, password
    request.env['HTTP_AUTHORIZATION'] = credentials
  end

  describe "GET index" do
    
    it "assigns the correct instance variables" do
      unpublished_sticky_article     = Article.make!(:sticky => true, :published => false)
      unpublished_non_sticky_article = Article.make!(:sticky => false, :published => false)
      published_sticky_article       = Article.make!(:sticky => true, :published => true)
      published_non_sticky_article   = Article.make!(:sticky => false, :published => true)

      basic_auth 'admin', 'admin'
      get :index, :locale => 'en'

      assigns(:unpublished_sticky_articles ).should     == [unpublished_sticky_article]
      assigns(:unpublished_non_sticky_articles ).should == [unpublished_non_sticky_article]
      assigns(:published_sticky_articles ).should       == [published_sticky_article]
      assigns(:published_non_sticky_articles ).should   == [published_non_sticky_article]
    end
    
    
    it "renders the index template" do
      basic_auth 'admin', 'admin'
      get :index, :locale => 'en'
      response.should render_template('index')
    end
  
  end
end
