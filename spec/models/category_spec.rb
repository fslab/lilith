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

describe Category do
  it { should have_db_column(:id) }
  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:eva_id).of_type(:string) }

  it_should_behave_like "a timestamped model"

  it { should have_many(:events) }
  it { should have_many(:event_associations) }

  context "before destroy" do
    it "should destroy all its event associations" do
      category = described_class.make!

      event_associations = [
        CategoryEventAssociation.make!(:category_id => category),
        CategoryEventAssociation.make!(:category_id => category)
      ]

      category.destroy

      event_associations.each do |association|
        lambda {
          CategoryEventAssociation.find(association.id)
        }.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end