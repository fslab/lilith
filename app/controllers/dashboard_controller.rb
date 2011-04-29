class DashboardController < ApplicationController

  def show
    @sticky_articles = Article.published.sticky.limit(10)

    @articles = Article.published.non_sticky.limit(10)
  end

end