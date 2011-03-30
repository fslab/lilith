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

class Lilith::MockAgent
  attr_accessor :mock_document, :mock_document_file

  def initialize(options = {})
    @mock_document      = options[:mock_document]
    @mock_document_file = options[:mock_document_file]
  end

  def get(*args)
    page = Page.new(mock_document)

    yield page if block_given?

    page
  end

  def mock_document
    if @mock_document
      @mock_document
    elsif @mock_document_file
      @mock_document = Nokogiri.parse(@mock_document_file.read)
    end
  end
end

class Lilith::MockAgent::Page
  def initialize(mock_document)
    @mock_document = mock_document
  end

  def search(*args)
    @mock_document.search(*args)
  end
end