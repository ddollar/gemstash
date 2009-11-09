require 'rubygems/command'
require 'rest_client'
require 'gemstash'

class Gem::Commands::StashCommand < Gem::Command

  GEMSTASH_DEFAULT_URL = 'http://gemstash.local'

  def initialize
    super 'stash', 'Upload a gem to Gemstash'

    add_option('-s', '--stash STASH', 'specify a stash to send to') do |stash, args|
      options[:stash] = stash
    end
  end

  def arguments
    "GEMFILE  the .gem to stash"
  end

  def usage
    "#{program_name} GEMFILE"
  end

  def execute
    configure_gemstash! unless Gem.configuration[:gemstash]
    gemfile = options[:args].first

    raise "Could not find GEMFILE: #{gemfile}" unless File.exists?(gemfile)

    http['gems'].post File.read(gemfile)

  rescue Exception => ex
    say "Exception: #{ex.message}"
  end

private ######################################################################

  def default_stash
    Gem.configuration[:gemstash][:stash]
  end

  def gemstash_key
    Gem.configuration[:gemstash][:key]
  end

  def gemstash_url
    ENV['GEMSTASH_URL'] || GEMSTASH_DEFAULT_URL
  end

## configuration #############################################################

  def configure_gemstash!
    say "It seems like this is your first time stashing a gem."
    say "You can find your API key at http://gemstash.org/profile"

    key   = ask_until_answered 'Gemstash API Key'
    stash = ask_until_answered 'Default Stash', options[:stash]

    Gem.configuration[:gemstash] = { :key => key, :stash => stash }
    Gem.configuration.write
  end

  def ask_until_answered(prompt, default=nil)
    message  = prompt
    message += " [#{default}]" if default
    message += ":"

    loop do
      answer = ask(message)
      answer = default if answer.strip == ''
      break(answer) if answer
    end
  end

## http ######################################################################

  def http
    RestClient::Resource.new gemstash_url, 
      :user    => gemstash_key, 
      :headers => { 'Client-Version' => Gemstash::VERSION }
  end

end
