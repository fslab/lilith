class Lilith::Holiday

  attr_reader :name

  def initialize(*arguments)
    case arguments.length
    when 2
      date, name = *arguments
      @date = Date.new(date.year, date.month, date.day)
    when 4
      year, month, day, name = *arguments
      @date = Date.new(year, month, day)
    else
      raise ArgumentError, 'invalid argument count'
    end
    @name = name.freeze
  end

  def eql?(other)
    self == other and other.is_a?(self.class)
  end

  def ==(other)
    @date == other.to_date
  end

  def <=>(other)
    @date <=> other.to_date
  end

  alias old_respond_to? respond_to?

  def respond_to?(name, include_private = false)
    old_respond_to?(name, include_private) or @date.respond_to?(name, include_private)
  end

  protected

  def method_missing(name, *arguments)
    @date.method(name).call(*arguments)
  end

end