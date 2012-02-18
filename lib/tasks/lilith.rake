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

# rake tasks for Lilith, usage:
# e.g.: rake lilith:scape_eva

namespace :lilith do

  desc "Scrapes the Eva system and saves acquired data into the database"
  task :scrape_eva => :environment do
    Lilith.scrape_eva
  end

  desc "Scrapes the public university website and saves the acquired people records to the database"
  task :scrape_people => :environment do
    Lilith.scrape_people
  end

  desc "Build news articles from the changelog.yml"
  task :release_articles => :environment do
    Lilith.generate_release_articles
  end

  desc "Execute all tasks in namespace lilith in sequentially"
  task :all_tasks => [:scrape_eva, :scrape_people, :release_articles] do
    # execute all Lilith tasks
  end
end
