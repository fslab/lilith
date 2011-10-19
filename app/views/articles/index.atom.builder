atom_feed(language: I18n.locale, link: dashboard_path) do |feed|
  feed.title("#{Rails.configuration.application_name} - #{Rails.configuration.application_slogan}")
  feed.updated(@all_articles.first.published_at)


  @all_articles.each do |article|
    feed.entry(article, url: article_path(article)) do |entry|
      entry.title article.name, type: 'html'
      entry.content((textilize article.body.blank? ? t('global.translation_missing') : article.body), type: 'html')

      entry.author do |author|
        author.name('Lilith-Team')
      end
    end
  end
end