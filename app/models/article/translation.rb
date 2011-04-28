# Contains translations for Article
class Article::Translation < Globalize::ActiveRecord::Translation
  set_table_name 'article_translations'
  
  include Lilith::UUIDHelper
end