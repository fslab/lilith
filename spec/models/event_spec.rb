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

describe Event do
  it { should have_db_column(:first_start).of_type(:datetime) }
  it { should have_db_column(:first_end).of_type(:datetime) }
  it { should have_db_column(:recurrence).of_type(:string) }
  it { should have_db_column(:until).of_type(:date) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }

  it { should belong_to(:course) }
  it { should belong_to(:schedule) }
  
  it { should have_many(:groups) }
  it { should have_many(:categories) }
  it { should have_many(:tutors) }
  it { should have_many(:weeks) }
end