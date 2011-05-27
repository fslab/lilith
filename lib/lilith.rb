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

# Namespace for Lilith, the student information collection service
#
# Additionally this acts as a facade to make using the scraping engines easier
module Lilith
  # The versioning tries to follow semantic versioning
  #
  # See http://semver.org/
  VERSION = '0.2.0alpha'

  module_function

  # Scrapes the main data source: Eva² of Hochschule Bonn-Rhein-Sieg
  #
  # For console debug output use
  #
  #   Lilith.scrape_eva(:logger => :console)
  def scrape_eva(options = {})
    HbrsEvaScraper.new(scraper_options_helper(options)).call
  end

  # Scrapes the people list of Hochschule Bonn-Rhein-Sieg and merges
  # the results with the existing objects in database
  def scrape_people(options = {})
    HbrsPeopleScraper.new(scraper_options_helper(options)).call
  end

  # Translates options for a better interface
  def scraper_options_helper(options)
    result_options = options.dup

    if options[:logger] == :console
      result_options[:logger] = Logger.new(STDOUT)
    end

    result_options
  end

  # Returns a default scraper agent
  def default_agent
    unless @default_agent
      @default_agent = Mechanize.new
      original, library = */(.*) \(.*\)$/.match(@default_agent.user_agent)
      @default_agent.user_agent = "Lilith/#{Lilith::VERSION} #{library} (https://www.fslab.de/redmine/projects/lilith/)"
    end

    @default_agent
  end

  # Allows to set the default scraper agent
  def default_agent=(default_agent)
    @default_agent = default_agent
  end

  # Returns the correct type for foreign key database columns
  def db_reference_type
    case Rails.configuration.database_configuration[Rails.env]['adapter']
    when 'postgresql'
      'uuid'
    when 'sqlite3'
      'text'
    when 'mysql', 'mysql2'
      'char(36)'
    end
  end

  # Returns the correct type for primary key database columns
  def db_primary_key_type
    case Rails.configuration.database_configuration[Rails.env]['adapter']
    when 'postgresql'
      'uuid PRIMARY KEY'
    when 'sqlite3'
      'text PRIMARY KEY'
    when 'mysql', 'mysql2'
      'char(36) PRIMARY KEY'
    end
  end

  def generate_release_articles
    changelog_file = Rails.root + 'changelog.yml'

    unless changelog = YAML.load(changelog_file.open)
      raise "Changelog is invalid (#{changelog_file})"
    end

    if not releases = changelog.try(:[], 'releases') or releases.empty?
      Rails.logger.warn "No releases specified in changelog (#{changelog_file})"
    end

    releases.each do |release|
      unless version = release['version']
        Rails.logger.warn "Skipping release without version"
        next
      end

      time = release['time'] || Time.now

      article = Article::Release.find_by_version(version)

      unless article
        article = Article::Release.new(
          :version => version,
          :created_at => time,
          :updated_at => time,
          :published_at => time
        )
      end

      I18n.available_locales.each do |locale|
        template_file = Rails.root + 'app' + 'views' + 'articles' + "release.#{locale}.textile.erb"
        template = template_file.read

        article.write_attribute(:name, I18n.t('article.release_name', :locale => locale).gsub(/%VERSION%/, version), :locale => locale)

        params = OpenStruct.new(
          :version  => version,
          :features => release['features'].try(:map, &lambda {|feature| feature[locale.to_s] }) || [],
          :bugs     => release['bugs'].try(:map, &lambda {|feature| feature[locale.to_s] }) || [],
          :url      => release['url'],
          :abstract => true
        )

        def params.get_binding
          binding
        end

        abstract_content = ERB.new(template).result(params.get_binding)

        params.abstract = false

        body_content = ERB.new(template).result(params.get_binding)

        article.write_attribute(:abstract, abstract_content, :locale => locale)
        article.write_attribute(:body,     body_content,     :locale => locale)
      end

      article.save!
    end
  end
end
