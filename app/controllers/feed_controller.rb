class FeedController < ApplicationController
  def show

  end

  def feed

  end

  def complete
    @feed_complete = Article.published

    respond_to do |format|
      format.atom
    end
  end

  def reduced
    @feed_reduced = Article.published.limit(10)

    respond_to do |format|
      format.atom
    end
  end
end