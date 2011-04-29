class ChangeBodyAndAbstractToTextForArticleTranslations < ActiveRecord::Migration
  def self.up
    change_column(:article_translations, :body, :text)
    change_column(:article_translations, :abstract, :text)
  end

  def self.down
    change_column(:article_translations, :body, :string)
    change_column(:article_translations, :abstract, :string)
  end
end
