atom_feed(:language => I18n.locale) do |feed|
  feed.title('Lilith - plan your schedule, really')
  feed.updated(@feed_complete.first.published_at)

  @feed_complete.each do |article|
    feed.entry(article) do |entry|
      entry.title(article.name)
      entry.content((textilize (article.body.blank? ? t('global.translation_missing') : article.body)), :type => 'html')
    end
  end
end