class ArticleTranslation < ActiveRecord::Base
  include Lilith::UUIDHelper

  puret_for :article
end