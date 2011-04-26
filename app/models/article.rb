class Article < ActiveRecord::Base
  include Lilith::UUIDHelper

  validates :name, :presence => true
  validates :body, :presence => true

  def publish
    if @article.published_at == nil and params[:article][:published] == 1
      @article.published_at = Time.now
    end
  end

end
