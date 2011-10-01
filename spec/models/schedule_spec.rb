require 'spec_helper'

describe Schedule do
  it { should have_db_column(:id) }
  it { should have_db_column(:user_id) }
  it { should have_db_column(:fixed_schedule_state_id) }
  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:description).of_type(:text) }
  it { should have_db_column(:public).of_type(:boolean) }

  it_should_behave_like "a timestamped model"

  it { should have_db_index(:user_id) }
  it { should have_db_index([:user_id, :name]).unique(true) }

  it { should belong_to(:user) }
  it { should belong_to(:fixed_schedule_state) }
  it { should have_many(:course_associations) }
  it { should have_many(:courses) }
  it { should have_many(:group_associations) }
  it { should have_many(:groups) }

  context "validations" do
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

  context "#schedule_state" do
    it "should return the latest schedule state if it is not fixed" do
      older_state  = ScheduleState.make!
      latest_state = ScheduleState.make!

      schedule = described_class.make(:fixed_schedule_state_id => nil)
      schedule.schedule_state.should == latest_state
    end

    it "should return the fixed schedule state if it is fixed" do
      older_state  = ScheduleState.make!
      latest_state = ScheduleState.make!

      schedule = described_class.make(:fixed_schedule_state_id => older_state.id)
      schedule.schedule_state.should == older_state
    end
  end

  context "#events" do
    it "should accumulate events from all associated event sources for the fixed schedule state" do
      course = Course.make!
      first_group = Group.make!(:course_id => course)
      second_group = Group.make!(:course_id => course)
      schedule_state = ScheduleState.make!
      other_schedule_state = ScheduleState.make!

      course_event       = Event.make!(:schedule_state_id => schedule_state)
      wrong_course_event = Event.make!(:schedule_state_id => other_schedule_state)

      first_group_event       = Event.make!(:schedule_state_id => schedule_state)
      wrong_first_group_event = Event.make!(:schedule_state_id => other_schedule_state)

      second_group_event = Event.make!(:schedule_state_id => schedule_state)
      some_other_event   = Event.make!(:schedule_state_id => schedule_state)

      course.events = [course_event, wrong_course_event]
      first_group.events = [first_group_event, wrong_first_group_event]
      second_group.events << second_group_event

      schedule = described_class.new
      schedule.fixed_schedule_state = schedule_state
      schedule.courses << course
      schedule.groups << first_group

      schedule.events.should == Set.new([
        first_group_event,
        course_event
      ])
    end

    it "should accumulate events from all associated event sources for the latest schedule state if not fixed" do
      course = Course.make!
      first_group = Group.make!(:course_id => course)
      second_group = Group.make!(:course_id => course)
      other_schedule_state = ScheduleState.make!
      schedule_state = ScheduleState.make!

      course_event       = Event.make!(:schedule_state_id => schedule_state)
      wrong_course_event = Event.make!(:schedule_state_id => other_schedule_state)

      first_group_event       = Event.make!(:schedule_state_id => schedule_state)
      wrong_first_group_event = Event.make!(:schedule_state_id => other_schedule_state)

      second_group_event = Event.make!(:schedule_state_id => schedule_state)
      some_other_event   = Event.make!(:schedule_state_id => schedule_state)

      course.events = [course_event, wrong_course_event]
      first_group.events = [first_group_event, wrong_first_group_event]
      second_group.events << second_group_event

      schedule = described_class.new
      schedule.courses << course
      schedule.groups << first_group

      schedule.events.should == Set.new([
        first_group_event,
        course_event
      ])
    end
  end

  context "#to_ical" do
    it "correctly convert the all events and additional data into an iCalendar object" do
      course = Course.make!
      group = Group.make!(:course_id => course)

      schedule_state = ScheduleState.make!

      course_event = Event.make!(:schedule_state_id => schedule_state)
      group_event  = Event.make!(:schedule_state_id => schedule_state)

      course.events << course_event
      group.events << group_event

      schedule = described_class.new
      schedule.courses << course
      schedule.groups << group

      ical_object = schedule.to_ical
      ical_object.should be_a(RiCal::Component::Calendar)
      ical_object.prodid.should == "-//fslab.de/NONSGML Lilith #{Lilith::VERSION}/EN"
      ical_object.should have(2).events
    end
  end
end
