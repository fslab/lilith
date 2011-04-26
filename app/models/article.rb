class Article < ActiveRecord::Base
  include Lilith::UUIDHelper

  attr_accessor :published

  before_save :set_published_at

  validates :name, :presence => true
  validates :body, :presence => true

  def published
    @published || !!self.published_at
  end

  protected

  def set_published_at
    if published
      self.published_at = Time.now unless self.published_at
    else
      self.published_at = nil
    end
  end

end
