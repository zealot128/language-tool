require 'net/http'
require 'json'

module LanguageTool
  class ServerError < StandardError
  end

  class Check
    def initialize(ignore_words: [])
      @ignore_words = ignore_words
    end

    def check(text:, language: LanguageTool.default_language)
      request_full_text = text
      r = if text.include?("<")
            data = LanguageTool::HtmlToAnnotation.convert(text)
            request_full_text = data['annotation'].map { |i| i['markup'] || i['text'] }.join
            post("/v2/check", body: { data: data.to_json, language: })
          else
            post("/v2/check", body: { text:, language: })
          end
      LanguageTool::Result.new(
        request_full_text:,
        **JSON.parse(r.body, symbolize_names: true)
      ).tap { |result|
        result.ignore_words!(@ignore_words) if @ignore_words.any?
      }
    end

    private

    def post(path, body:)
      url = URI.join(LanguageTool.api_url, path)

      request = Net::HTTP::Post.new(url.path, {
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Accept' => 'application/json',
        # 'Accept-Encoding' => 'gzip'
      })
      request.body = URI.encode_www_form(body)

      response = Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
        http.request(request)
      end
      unless response.is_a?(Net::HTTPSuccess)
        raise ServerError, "Server returned status #{response.code}: #{response.body}"
      end
      response
    end
  end
end
