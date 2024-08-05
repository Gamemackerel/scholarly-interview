claude-ruby gem is an unofficial ruby SDK for interacting with the Anthropic API, for generating and streaming messages through Claude
Installation

Add this line to your application's Gemfile:

gem 'claude-ruby'

And then execute:

$ bundle install

Or install it yourself as:

$ gem install claude-ruby

Usage

To use this gem you'll need an API key from Anthropic, which can be obtained from the Anthropic console
by following the Get API Access link on the Anthropic API page.

Set your API key as an environment variable then you can create a new Claude::Client instance:

require 'claude/client'

api_key = ENV['YOUR_ANTHROPIC_API_KEY']
claude_client = Claude::Client.new(api_key)

Messages

The anthropic messages endpoint allows you to:

Send a structured list of input messages with text and/or image content, 
and the model will generate the next message in the conversation.
The Messages API can be used for for either single queries or stateless multi-turn conversations.

Using the claude-ruby gem you can call the Anthropic messages API by passing in an array of messages where each element is a hash containing role and content properties.

The messages method allows converse with the Claude model in chat form. It requires an array of messages where each message is a hash with two properties: role and content.

role can be:

    'user': This represents the user's input.
    'assistant': This optional role represents the model's output.

Simple example with a single user message:

messages = claude_client.user_message("Who was the first team to win the rugby world cup?")
response = claude_client.messages(messages)

The response contains a bunch of metadata and the model's message response. To extract the message text you can use:

claude_client.parse_response(response)

Or parse the response yourself:

response['content'][0]['text']

claude_client.user_message is just for simple user messages. For more complex messages you can specify the payload in detail:

messages = [
  {
    role: "user",
    content: "In which year was the first ever rugby world cup? (A) 1983 (B) 1987 (C) 1991"
  },
  {
    role: "assistant",
    content: "The best answer is ("
  }
]

response = claude_client.messages(messages)

You can continue the conversation by calling the messages method again with an expanded messages array:

messages = [{ role: "user", content: "Who was the first team to win the rugby world cup?" }]
messages << { role: "assistant", content: "New Zealand won the first Rugby World Cup in 1987" }
messages << { role: "user", content: "Who came third and fourth in that competition?" }

response = claude_client.messages(messages)
puts claude_client.parse_response(response) # This will give you the updated message

Example with a more sophisticated message structure:

system = "Only reply in Spanish."

messages = [
  {
    role: "user",
    content: "Hi there."
  },
  {
    role: "assistant",
    content: "Hola, como estás?"
  },
  {
    role: "user",
    content: "How long does it take to fly from Auckland to Buenos Aires?"
  },
]

response = claude_client.messages(messages, { system: system })

Models

If you don't specify a model, then the gem will use the latest version of Claude Sonnet by default, which is currently claude-3-5-sonnet-20240620

You can use a different model by specifying it as a parameter in the messages call:

response = claude_client.messages(messages, { model: 'claude-3-haiku-20240307' })

There are some constants defined so you can choose an appropriate model for your use-case and not have to worry about updating it when new Claude models are released:

Claude::Model::CLAUDE_OPUS_LATEST
Claude::Model::CLAUDE_SONNET_LATEST
Claude::Model::CLAUDE_HAIKU_LATEST

Claude::Model::CLAUDE_FASTEST
Claude::Model::CLAUDE_CHEAPEST
Claude::Model::CLAUDE_BALANCED
Claude::Model::CLAUDE_SMARTEST

Example usage:

response = claude_client.messages(messages, { model: Claude::Model::CLAUDE_CHEAPEST })

Timeout

You can optionally set a timeout (integer) which will determine the maximum number of seconds to wait for the API call to complete.

There are two ways to do this:

    Set a default timeout when instantiating the claude_client
    This timeout value will be used for all API calls unless overridden.

claude_client = Claude::Client.new(api_key, timeout: 10)

    Pass in a timeout value as a parameter when calling the messages method.
    This timeout value will be used only for that specific messages request.

response = claude_client.messages(messages, { timeout: 10 })

Parameters

You can pass in any of the following parameters, which will be included in the Anthropic API call:

model
system
max_tokens
metadata
stop_sequences
stream
temperature
top_p
top_k

timeout (*)

(*) timeout is used for the HTTP request but not passed with the API data

Example:

response = claude_client.messages(messages, 
                                  { model: Claude::Model::CLAUDE_SMARTEST,
                                    max_tokens: 500,
                                    temperature: 0.1 })

