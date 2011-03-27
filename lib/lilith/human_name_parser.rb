# encoding: UTF-8

class Lilith::HumanNameParser
  STATES = [:title, :forename, :middlename, :surname].freeze

  attr_accessor :debug

  def initialize(name)
    @words = name.chomp.strip.split(/ /)
  end

  def parse
    @result = {}
    @states = STATES.each
    @state = @states.next

    while word = @words.shift
      loop do
        case method(@state).call(word)
        when :success
          debug "'#{word}' classified as #{@state}"
          @result[@state] ||= []
          @result[@state] << word
          break
        when :success_and_next
          debug "'#{word}' classified as #{@state}"
          @result[@state] ||= []
          @result[@state] << word
          @state = @states.next
          debug "Progressing state to: #{@state}"
          break
        when false
          debug "'#{word}' is no #{@state}"
          @state = @states.next
          debug "Progressing state to: #{@state}"
        end
      end
    end

    @result.each do |part, words|
      @result[part] = words.join(' ') if words
    end
  end

  protected

  def title(word)
    if word.include?('.')
      :success
    else
      false
    end     
  end

  def forename(word)
    :success_and_next
  end

  def middlename(word)
    first_char = word.chars.first
    if first_char.downcase == first_char or @words.empty?
      false
    else
      :success
    end     
  end
   
  def surname(word)
    :success_and_next
  end

  def debug(text = nil)
    puts text if @debug
  end
end

