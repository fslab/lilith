require 'spec_helper'

describe CategoryEventAssociation do
  it { should have_db_column(:id) }
  it { should have_db_column(:category_id) }
  it { should have_db_column(:event_id) }

  it_should_behave_like "a timestamped model"

  it { should belong_to(:category) }
  it { should belong_to(:event) }
end