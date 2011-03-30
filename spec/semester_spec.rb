require 'spec_helper'

describe Semester do
  it { should have_db_column(:season).of_type(:string) }
  it { should have_db_column(:start_year).of_type(:integer) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }
  
  it { should have_many(:study_units) }
end