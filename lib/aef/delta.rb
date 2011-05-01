# encoding: UTF-8
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