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

source 'http://rubygems.org'

gem 'rails', '3.1.1'

group :assets do
  gem 'sass-rails', '~> 3.1.0'
  gem 'coffee-rails', '~> 3.1.0'
  gem 'uglifier', '~> 1.0.3'
  gem 'therubyracer', '~> 0.9.4', :platforms => :ruby
end

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg', '~> 0.11.0' # PostgreSQL is the recommended database system
#gem 'sqlite3', '~> 1.3.4'
#gem 'mysql2', '~> 0.2.7'

gem 'rake', '~> 0.9.2'
gem 'haml', '~> 3.1.2'
gem 'mechanize', '~> 1.0.0'
gem 'ri_cal', '~> 0.8.8'
gem 'amatch', '~> 0.2.5'
gem 'uuidtools', '~> 2.1.2'
gem 'whenever', '~> 0.6.7'
gem 'RedCloth', '= 4.2.9', :require => 'redcloth'
gem 'globalize3', '~> 0.1.0'
gem 'jquery-rails', '~> 1.0.13'
gem 'acceptable', '~> 0.2.3', :require => 'rack/acceptable'
gem 'foreigner', '~> 0.9.2'
gem 'authlogic', '~> 3.0.3'
gem 'cancan', '~> 1.6.5'
gem 'rspec-rails', '~> 2.6.1', :groups => [:development, :test]
gem 'date_easter', '~> 0.0.1'
gem 'kaminari', '~> 0.12.4'
gem 'nokogiri', '~> 1.5.0'
gem 'simple-navigation', '~> 3.5.0'
gem 'mixable_engines', '~> 0.1.1'
gem 'activeldap', '~> 3.1.0', :require => 'active_ldap'
gem 'weekling', '~> 1.0.0', require: 'weekling/bare' # FIXME: Disable bare mode when Lilith is completely namespaced

platforms :ruby do
  gem 'ruby-ldap', '~> 0.9.11'
end

platforms :mswin, :mingw do
  gem 'net-ldap', '~> 0.2.2'
end

group :development do
  gem 'wirble', '~> 0.1.3'
end

group :test do
  gem 'shoulda-matchers', '~> 1.0.0.beta3'
  gem 'machinist', '~> 2.0.0.beta2'
  gem 'simplecov', '~> 0.5.4'
end
