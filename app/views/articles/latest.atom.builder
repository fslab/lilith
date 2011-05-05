atom_feed(:language => I18n.locale) do |feed|
  feed.title("#{Rails.configuration.application_name} - #{Rails.configuration.application_slogan}")
  feed.updated(@latest_articles.first.published_at)

  @latest_articles.each do |article|
    feed.entry(article) do |entry|
      entry.title(article.name)
      entry.content((textilize (article.body.blank? ? t('global.translation_missing') : article.body)), :type => 'html')
    end
  end
end