class Article::Release < Article
  validates :version, :presence => true
end