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
