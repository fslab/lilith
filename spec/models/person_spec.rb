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

describe Person do
  it { should have_db_column(:title).of_type(:string) }
  it { should have_db_column(:forename).of_type(:string) }
  it { should have_db_column(:middlename).of_type(:string) }
  it { should have_db_column(:surname).of_type(:string) }
  it { should have_db_column(:eva_id).of_type(:string) }
  it { should have_db_column(:profile_url).of_type(:string) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }

  it { should have_many(:events) }

  context "#name" do
    it "should display a correct name" do
      @person = described_class.make(
        :title      => 'Lord',
        :forename   => 'Omar',
        :middlename => 'Kayyam',
        :surname    => 'Ravenhurst'
      )

      @person.name.should == 'Lord Omar Kayyam Ravenhurst'
    end

    it "should display a correct name if no title is set" do
      @person = described_class.make(
        :title      => nil,
        :forename   => 'Omar',
        :middlename => 'Kayyam',
        :surname    => 'Ravenhurst'
      )

      @person.name.should == 'Omar Kayyam Ravenhurst'
    end

    it "should display a correct name if no forename is set" do
      @person = described_class.make(
        :title      => 'Lord',
        :forename   => nil,
        :middlename => 'Kayyam',
        :surname    => 'Ravenhurst'
      )

      @person.name.should == 'Lord Ravenhurst'
    end

    it "should display a correct name if no middlename is set" do
      @person = described_class.make(
        :title      => 'Lord',
        :forename   => 'Omar',
        :middlename => nil,
        :surname    => 'Ravenhurst'
      )

      @person.name.should == 'Lord Omar Ravenhurst'
    end

    it "should display a correct name if no forename and middlename is set" do
      @person = described_class.make(
        :title      => 'Lord',
        :forename   => nil,
        :middlename => nil,
        :surname    => 'Ravenhurst'
      )

      @person.name.should == 'Lord Ravenhurst'
    end

    it "should display a correct name if only surname is set" do
      @person = described_class.make(
        :title      => nil,
        :forename   => nil,
        :middlename => nil,
        :surname    => 'Ravenhurst'
      )

      @person.name.should == 'Ravenhurst'
    end

    it "should display a correct name if only eva_id is set" do
      @person = described_class.make(
        :title      => nil,
        :forename   => nil,
        :middlename => nil,
        :surname    => nil,
        :eva_id     => 'ravenhurst'
      )

      @person.name.should == 'ravenhurst'
    end
  end
end