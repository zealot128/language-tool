module LanguageTool
  # {:message=>"Möglicher Tippfehler gefunden.",
  #  :shortMessage=>"Rechtschreibfehler",
  #  :replacements=>[{:value=>"höchst relevantes"}],
  #  :offset=>897,
  #  :length=>16,
  #  :context=>{:text=>"...-Infrastruktur, die es ihnen ermöglicht höchstrelevantes Branchenwissen für eine bessere Persona...", :offset=>43, :length=>16},
  #  :sentence=>
  #   "Im Rahmen ihrer Mitgliedschaft erhalten unsere Kunden nicht nur uneingeschränkten Zugriff auf all unsere Webanwendungen, sondern sie nehmen Anteil an einer ausgeklügelten IT-Infrastruktur, die es ihnen ermöglicht höchstrelevantes Branchenwissen für eine bessere Personalgewinnung miteinander zu teilen.",
  #  :type=>{:typeName=>"UnknownWord"},
  #  :rule=>{:id=>"GERMAN_SPELLER_RULE", :description=>"Möglicher Rechtschreibfehler", :issueType=>"misspelling", :category=>{:id=>"TYPOS", :name=>"Mögliche Tippfehler"}},
  #  :ignoreForIncompleteSentence=>false,
  #  :contextForSureMatch=>0}]

  Match = Struct.new(:message, :short_message, :replacements, :offset, :length, :context, :sentence, :type, :rule, :ignore_for_incomplete_sentence,
                     :context_for_sure_match, :full_text, keyword_init: true) do
    def highlighted_text
      range = offset...(offset + length)
      full_text[range]
    end

    def as_json(opts = {})
      super(opts).merge('highlighted_text' => highlighted_text)
    end

    def to_s
      "#{message} (#{short_message}) #{highlighted_text} -> #{replacements.join(', ')}"
    end
  end
  def Match.for(hash, full_text)
    Match.new(
      message: hash[:message],
      short_message: hash[:shortMessage],
      replacements: hash[:replacements].map { |r| r[:value] },
      offset: hash[:offset],
      length: hash[:length],
      context: hash[:context],
      sentence: hash[:sentence],
      type: hash[:type][:typeName],
      rule: hash[:rule],
      ignore_for_incomplete_sentence: hash[:ignoreForIncompleteSentence],
      context_for_sure_match: hash[:contextForSureMatch],
      full_text:
    )
  end
end
