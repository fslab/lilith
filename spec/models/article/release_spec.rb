require 'spec_helper'

describe Article::Release do
  it { should have_db_column(:id) }
  it { should have_db_column(:sticky).of_type(:boolean) }
  it { should have_db_column(:published_at).of_type(:datetime) }
  it { should have_db_column(:version).of_type(:string) }
  it { should have_db_column(:type).of_type(:string) }

  it_should_behave_like "a timestamped model"

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:version) }

  it "should validate the uniqueness of the version attribute" do
    first_article = Article::Release.make(:version => '1.0.0')
    first_article.save!

    second_article = Article::Release.make(:version => '1.0.0')
    second_article.save

    second_article.errors[:version].should have(1).item
  end
end