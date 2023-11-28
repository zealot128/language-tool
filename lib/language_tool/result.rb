module LanguageTool
  # Result =  [:software, :warnings, :language, :matches, :sentenceRanges]
  Result = Struct.new(:software, :warnings, :language, :matches, :sentenceRanges, :request_full_text, keyword_init: true) do
    def matches
      @_matches ||= self[:matches].map { |m| LanguageTool::Match.for(m, request_full_text) }
    end

    def ignore_words!(list)
      matches.reject! { |m| list.include?(m.highlighted_text) }
    end
  end
end
