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

module Aef
  
end

module Aef::DeltaMixin
  # Absolute difference between two Numerics
  def delta(other)
    (self - other).abs
  end

  #alias Δ delta
end

class Numeric
  include Aef::DeltaMixin
end

class Date
  include Aef::DeltaMixin
end

class DateTime
  include Aef::DeltaMixin
end

class Time
  include Aef::DeltaMixin
end

class ActiveSupport::TimeWithZone
  include Aef::DeltaMixin
end