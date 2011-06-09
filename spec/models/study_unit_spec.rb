# encoding: UTF-8
=begin
Copyright Alexander E. Fischer <aef@raxys.net>, 2011

This file is part of Lilith.

Lilith is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Lilith is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Lilith.  If not, see <http://www.gnu.org/licenses/>.
=end

require 'spec_helper'

describe StudyUnit do
  it { should have_db_column(:id) }
  it { should have_db_column(:program).of_type(:string) }
  it { should have_db_column(:position).of_type(:integer) }
  it { should have_db_column(:eva_id).of_type(:string) }
  
  it_should_behave_like "a timestamped model"

  it { should belong_to(:semester) }

  it { should have_many(:courses) }

  context "before destroy" do
    it "should destroy all its courses" do
      study_unit = described_class.make!

      courses = [
        Course.make!(:study_unit_id => study_unit),
        Course.make!(:study_unit_id => study_unit)
      ]

      study_unit.destroy

      courses.each do |course|
        lambda {
          Course.find(course.id)
        }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end