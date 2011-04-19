require 'spec_helper'


describe Article do 
  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:published_at).of_type(:datetime) }
  it { should have_db_column(:abstract).of_type(:text) }
  it { should have_db_column(:body).of_type(:text) }
end
