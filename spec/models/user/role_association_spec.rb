require 'spec_helper'

describe User::RoleAssociation do
  it { should have_db_column(:id) }
  it { should have_db_column(:user_id) }
  it { should have_db_column(:role_id) }

  it_should_behave_like "a timestamped model"

  it { should have_db_index(:user_id) }
  it { should have_db_index(:role_id) }
  it { should have_db_index([:user_id, :role_id]).unique(true) }

end