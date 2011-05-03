atom_feed(:language => I18n.locale) do |feed|
  feed.title('Lilith - plan your schedule, really')
  feed.updated(@feed_reduced.first.published_at)

  @feed_reduced.each do |article|
    feed.entry(article) do |entry|
      entry.title(article.name)
      entry.content((textilize (article.body.blank? ? t('global.translation_missing') : article.body)), :type => 'html')
    end
  end
end