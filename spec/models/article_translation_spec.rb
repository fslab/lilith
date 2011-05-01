require 'spec_helper'

describe Article::Translation do
  it { should have_db_column(:id) }
  it { should have_db_column(:article_id) }
  it { should have_db_column(:locale).of_type(:string) }
  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:abstract).of_type(:text) }
  it { should have_db_column(:body).of_type(:text) }

  it_should_behave_like "a timestamped model"
end