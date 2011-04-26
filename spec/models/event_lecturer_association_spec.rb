require 'spec_helper'

describe EventLecturerAssociation do
  it { should have_db_column(:id) }
  it { should have_db_column(:event_id) }
  it { should have_db_column(:lecturer_id) }

  it_should_behave_like "a timestamped model"

  it { should belong_to(:event) }
  it { should belong_to(:lecturer) }
end