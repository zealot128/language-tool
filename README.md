# LanguageTool Api Client (minimal)

This is a minmal Api-Client for a self-hosted Language-Tool server. So it only supports the /v2/check endpoint, no words or user management.

It automatically handles HTML text and converts it into an annotation format that LT understands.

## Usage

```ruby
gem 'language-tool'
```

```ruby
LanguageTool.api_url = '...'
LanguageTool.default_language = 'auto' # or de-DE or en-US or ...

result = LanguageTool.check(text: 'This is a test.', language: 'en-US')
result.matches.count == 0

# Ignore lists:

check = LanguageTool::Check.new(ignore_list: ['pludoni', 'GmbH'])
result = check.check(text: 'Ignoriere Eigennamen wie pludoni GmbH.', language: 'en-US')
result.matches.count == 0
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
