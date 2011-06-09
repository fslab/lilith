require 'spec_helper'

describe Schedule::GroupAssociation do
  it { should have_db_column(:id) }
  it { should have_db_column(:schedule_id) }
  it { should have_db_column(:group_id) }

  it_should_behave_like "a timestamped model"

  it { should have_db_index(:schedule_id) }
  it { should have_db_index(:group_id) }
  it { should have_db_index([:schedule_id, :group_id]).unique(true) }

  it { should belong_to(:schedule) }
  it { should belong_to(:group) }

  it "should validate the uniqueness of group per schedule" do
    @first_association  = described_class.make!
    @second_association = described_class.make
    @second_association.schedule = @first_association.schedule
    @second_association.group    = @first_association.group

    @second_association.should_not be_valid
    @second_association.errors[:group_id].should have_at_least(1).item
  end
end