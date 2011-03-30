require 'spec_helper'

describe Course do
  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:profile_url).of_type(:string) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }

  it { should belong_to(:study_unit) }

  it { should have_many(:events) }
end