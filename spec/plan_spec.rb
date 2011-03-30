require 'spec_helper'

describe Plan do
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }

  it { should belong_to(:study_unit) }

  it { should have_many(:events) }
end