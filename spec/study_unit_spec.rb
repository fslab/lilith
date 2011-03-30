require 'spec_helper'

describe StudyUnit do
  it { should have_db_column(:program).of_type(:string) }
  it { should have_db_column(:position).of_type(:integer) }
  it { should have_db_column(:eva_id).of_type(:string) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }

  it { should belong_to(:semester) }

  it { should have_many(:courses) }
  it { should have_many(:plans) }
end