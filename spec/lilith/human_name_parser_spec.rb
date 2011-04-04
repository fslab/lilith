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
require 'lilith/human_name_parser'

describe Lilith::HumanNameParser do
  it "should require a name for initialization" do
    lambda {
      described_class.new(nil)
    }.should raise_error(ArgumentError, 'A name must be given')
  end

  it "should be able to split names into their components (1)" do
    parser = described_class.new('Prof. Dr. Jochen M. A. von der Zwuckelheide')

    result = parser.parse

    result.should be_a(Hash)
    result.keys.to_set.should == [:title, :forename, :middlename, :surname].to_set

    result[:title].should == 'Prof. Dr.'
    result[:forename].should == 'Jochen'
    result[:middlename].should == 'M. A.'
    result[:surname].should == 'von der Zwuckelheide'
  end

  it "should be able to split names into their components (2)" do
    parser = described_class.new('Michaela Ulrike Shimshon-Buddelwasser')

    result = parser.parse

    result.should be_a(Hash)
    result.keys.to_set.should == [:forename, :middlename, :surname].to_set

    result[:forename].should == 'Michaela'
    result[:middlename].should == 'Ulrike'
    result[:surname].should == 'Shimshon-Buddelwasser'
  end
end