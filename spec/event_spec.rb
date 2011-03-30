require 'spec_helper'

describe Event do
  it { should have_db_column(:first_start).of_type(:datetime) }
  it { should have_db_column(:first_end).of_type(:datetime) }
  it { should have_db_column(:recurrence).of_type(:string) }
  it { should have_db_column(:until).of_type(:date) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }

  it { should belong_to(:course) }
  
  it { should have_many(:groups) }
  it { should have_many(:categories) }
  it { should have_many(:tutors) }

end