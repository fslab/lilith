require 'spec_helper'

describe Schedule::CourseAssociation do
  it { should have_db_column(:id) }
  it { should have_db_column(:schedule_id) }
  it { should have_db_column(:course_id) }

  it_should_behave_like "a timestamped model"

  it { should have_db_index(:schedule_id) }
  it { should have_db_index(:course_id) }
  it { should have_db_index([:schedule_id, :course_id]).unique(true) }

  it { should belong_to(:schedule) }
  it { should belong_to(:course) }

  it "should validate the uniqueness of course per schedule" do
    @first_association  = described_class.make!
    @second_association = described_class.make
    @second_association.schedule = @first_association.schedule
    @second_association.course   = @first_association.course

    @second_association.should_not be_valid
    @second_association.errors[:course_id].should have_at_least(1).item
  end
end
