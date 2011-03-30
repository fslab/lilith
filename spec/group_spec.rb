require 'spec_helper'

describe Group do
  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }

  it { should belong_to(:course) }

  it { should have_many(:events) }
end