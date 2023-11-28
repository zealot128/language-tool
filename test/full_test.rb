require "minitest/autorun"

require 'language_tool'

# this only works when run from a company's server! Replace with your own server or with LT's server for your test.
LanguageTool.api_url = "https://spellcheck.empfehlungsbund.de/v2"

describe LanguageTool do
  it "should check for spelling errors" do
    result = LanguageTool.check(text: "Das ist eine test.", language: "de-DE")
    _(result.matches.length).must_equal 1

    # for coverage
    result.matches.map(&:to_json)
  end

  it "should handle html fine for spelling errors" do
    result = LanguageTool.check(text: "<p>This is a fine test.</p><p>It should have no errors.</p>")
    _(result.matches.length).must_equal 0
  end

  it "should ignore known words by a dict html fine for spelling errors" do
    check = LanguageTool::Check.new(ignore_words: ['pludoni', 'gmbH'])
    result = check.check(text: "<p>Unsere Firma pludoni GmbH sollte funktionieren.</p>", language: 'de-DE')
    _(result.matches.length).must_equal 0
  end
end
