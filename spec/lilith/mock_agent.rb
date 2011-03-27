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