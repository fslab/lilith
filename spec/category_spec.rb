require 'spec_helper'

describe Category do
  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:eva_id).of_type(:string) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }

  it { should have_many(:events) }
end