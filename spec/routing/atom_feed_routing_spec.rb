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

describe "routes for Atom feed" do

  it "routes /de/articles.atom to the articles controller in atom format" do
    get("/de/articles.atom").should route_to("articles#index", :locale => 'de', :format => 'atom')
  end

  it "routes /en/articles.atom to the articles controller in atom format" do
     get("/en/articles.atom").should route_to("articles#index", :locale => 'en', :format => 'atom')
  end

  it "routes /de/articles/latest to the articles controller in atom format" do
     get("/de/articles/latest").should route_to("articles#latest", :locale => 'de', :format => 'atom')
  end

  it "routes /en/articles/latest.atom to the articles controller in atom format" do
      get("/en/articles/latest.atom").should route_to("articles#latest", :locale => 'en', :format => 'atom')
  end

end
