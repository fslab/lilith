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

describe "routes for Articles" do
  
  it "routes /de/articles to the articles controller" do
    get("/de/articles").should route_to("articles#index", :locale => 'de')
  end
  
  it "routes /en/articles to the articles controller" do
    get("/en/articles").should route_to("articles#index", :locale => 'en')
  end

  it "routes /en/articles/new to the articles controller" do
    get("/en/articles/new").should route_to("articles#new", :locale => 'en')
  end

  it "routes /en/articles to the articles controller" do
    post("/en/articles").should route_to("articles#create", :locale => 'en')
  end
  
  it "routes /en/articles to the articles controller" do
    uuid = UUIDTools::UUID.timestamp_create.to_s
    delete("/en/articles/#{uuid}").should route_to("articles#destroy", :locale => 'en', :id => uuid)
  end

  it "routes /en/articles to the articles controller" do
    uuid = UUIDTools::UUID.timestamp_create.to_s
    get("/en/articles/#{uuid}").should route_to("articles#show", :locale => 'en', :id => uuid)
  end
  
  it "routes /en/articles to the articles controller" do
    uuid = UUIDTools::UUID.timestamp_create.to_s
    get("/en/articles/#{uuid}/edit").should route_to("articles#edit", :locale => 'en', :id => uuid)
  end
  
end
