require 'spec_helper'

describe User do
  it { should have_db_column(:id) }
  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:login).of_type(:string) }
  it { should have_db_column(:persistence_token).of_type(:string) }

  it_should_behave_like "a timestamped model"

  it { should have_many(:role_associations) }
  it { should have_many(:roles) }
  it { should have_many(:schedules) }

  context "default order" do
    it "should order by login in a ascending way" do
      first_user  = described_class.make!(:login => 'adam')
      second_user = described_class.make!(:login => 'zirbel')

      users = described_class.all
      users.index(first_user).should < users.index(second_user)
    end
  end
end
