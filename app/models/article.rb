class Article < ActiveRecord::Base
  include Lilith::UUIDHelper

  puret :name, :body, :abstract

  attr_accessor :published

  before_save :set_published_at

  validates :name, :presence => true
  validates :body, :presence => true

  default_scope order('published_at DESC, updated_at DESC')

  def self.sticky
    where(:sticky => true)
  end

  def self.non_sticky
    where(:sticky => false)
  end

  def self.published
    where('published_at IS NOT NULL')
  end

  def self.unpublished
    where('published_at IS NULL')
  end

  def published
    if @published == true or @published == false
      @published
    else
      !!self.published_at
    end
  end

  alias published? published

  protected

  def set_published_at
    if published?
      self.published_at = Time.now unless self.published_at
    else
      self.published_at = nil
    end
  end

end
