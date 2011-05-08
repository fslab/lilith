class Article::Release < Article
  validates :version, :presence => true, :uniqueness => true
end