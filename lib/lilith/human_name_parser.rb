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

# Takes a human name and splits it into title, forename, middlenames and surname
class Lilith::HumanNameParser
  STATES = [:title, :forename, :middlename, :surname].freeze

  attr_accessor :debug

  # Creates a parser object for a given name
  def initialize(name)
    raise ArgumentError, 'A name must be given' unless name
    
    # delete part of name after comma
    name = name.gsub(/\,[^\/]*$/, "")
    
    # splitt name into array
    @words = name.to_s.chomp.strip.split(/ /)
  end

  # Parses the name and returns a hash with name components
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

