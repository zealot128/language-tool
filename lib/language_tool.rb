module LanguageTool
  class ServerError < StandardError
  end

  class << self
    attr_accessor :api_url, :default_language
  end

  self.api_url = ""
  self.default_language = "auto"

  autoload :Check, "language_tool/check"
  autoload :HtmlToAnnotation, "language_tool/html_to_annotation"
  autoload :Match, "language_tool/match"
  autoload :Result, "language_tool/result"
  autoload :VERSION, "language_tool/version"

  def self.check(**args)
    Check.new.check(**args)
  end
end
