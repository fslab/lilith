class Lilith::TextileTemplateHandler < ActionView::Template::Handler
  def self.call(template)
    "'#{RedCloth.new(template.source).to_html}'"
  end
end

ActionView::Template.register_template_handler(:textile, Lilith::TextileTemplateHandler)