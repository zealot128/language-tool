require 'nokogiri'
module LanguageTool
  class HtmlToAnnotation
    def self.convert(html)
      new.convert(html)
    end

    def convert(html)
      doc = Nokogiri::HTML.fragment(html)
      { "annotation" => doc.children.map { |node| convert_to_json(node) }.flatten }
    end

    def convert_to_json(node, result = [])
      if node.text?
        result << { "text" => node.text }
      elsif node.element?
        markup = "<#{node.name}>"
        result << r = { "markup" => markup }
        # add "interpretAs": "\n\n" for p and br
        if node.name == "p" || node.name == "br"
          r["interpretAs"] = "\n\n"
        end
        node.children.each { |child| convert_to_json(child, result) }
        markup_end = "</#{node.name}>"
        result << { "markup" => markup_end }
      end
    end
  end
end
