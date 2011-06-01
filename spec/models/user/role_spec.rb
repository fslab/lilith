require 'spec_helper'

describe User::Role do
  it { should have_db_column(:id) }
  it { should have_db_column(:name).of_type(:string) }

  it { should have_many(:user_associations) }
  it { should have_many(:users) }

  it_should_behave_like "a timestamped model"

  it { should validate_uniqueness_of(:name) }

  context "default order" do
    it "should order by name in a ascending way" do
      first_role  = described_class.make!(:name => 'test_admin')
      second_role = described_class.make!(:name => 'test_normalo')

      roles = described_class.all
      roles.index(first_role).should < roles.index(second_role)
    end
  end
end