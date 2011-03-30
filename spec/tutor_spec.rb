require 'spec_helper'

describe Tutor do
  it { should have_db_column(:title).of_type(:string) }
  it { should have_db_column(:forename).of_type(:string) }
  it { should have_db_column(:middlename).of_type(:string) }
  it { should have_db_column(:surname).of_type(:string) }
  it { should have_db_column(:eva_id).of_type(:string) }
  it { should have_db_column(:profile_url).of_type(:string) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }

  it { should have_many(:events) }
end