# A single entry of the news feed
class Article < ActiveRecord::Base
  include Lilith::UUIDHelper

  translates :name, :abstract, :body

  attr_writer :published

  before_save :set_published_at

  validates :name, :presence => true
  validates :body, :presence => true

  # Default order for articles
  default_scope order('published_at DESC, updated_at DESC')

  # Selects only sticky articles
  def self.sticky
    where(:sticky => true)
  end

  # Selects only non-sticky articles
  def self.non_sticky
    where(:sticky => false)
  end

  # Selects only published articles
  def self.published
    where('published_at IS NOT NULL')
  end

  # Selects only unpublished articles
  def self.unpublished
    where('published_at IS NULL')
  end

  # Define reader and writer methods for supported locales
  #
  # Example:
  #
  #   article.name_en = 'The title'
  #   article.body_de
  translated_attribute_names.each do |attribute|
    I18n.available_locales.each do |locale|
      define_method "#{attribute}_#{locale}" do
        read_attribute(attribute, :locale => locale)
      end

      define_method "#{attribute}_#{locale}=" do |value|
        write_attribute(attribute, value, :locale => locale)
      end
    end
  end

  # Virtual attribute reflecting if the article is currently published
  def published?
    if @published == true or @published == false
      @published
    else
      !!self.published_at
    end
  end

  protected

  # If published? is true, set the published_at timestamp if not already set,
  # if published? is false, keep or set published_at timestamp to nil
  def set_published_at
    if published?
      self.published_at = Time.now unless self.published_at
    else
      self.published_at = nil
    end
  end

end
