require 'spec_helper'

describe Schedule do
  it { should have_db_column(:id) }
  it { should have_db_column(:user_id) }
  it { should have_db_column(:schedule_state_id) }
  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:description).of_type(:text) }
  it { should have_db_column(:public).of_type(:boolean) }

  it_should_behave_like "a timestamped model"

  it { should have_db_index(:user_id) }
  it { should have_db_index([:user_id, :name]).unique(true) }

  it { should belong_to(:user) }
  it { should belong_to(:schedule_state) }
  it { should have_many(:course_associations) }
  it { should have_many(:courses) }

  it "should not validate the uniqueness of name globally" do
    @first_schedule  = described_class.make!
    @second_schedule = described_class.make(:name => @first_schedule.name)

    @second_schedule.should be_valid
  end

  it "should validate the uniqueness of name per user" do
    @first_schedule  = described_class.make!
    @second_schedule = described_class.make
    @second_schedule.user = @first_schedule.user
    @second_schedule.name = @first_schedule.name

    @second_schedule.should_not be_valid
    @second_schedule.errors[:name].should have_at_least(1).item
  end
end
