# encoding: utf-8

require "drb"
require "tweetstream"

class Stream
  def initialize(staff)
    @staff = staff
    configure
  end

  def configure
    TweetStream.configure do |config|
      config.consumer_key       = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret    = ENV["TWITTER_CONSUMER_SECRET"]
      config.oauth_token        = ENV["TWITTER_ACCESS_TOKEN"]
      config.oauth_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
      config.auth_method        = :oauth
    end
  end

  def main_loop
    client = TweetStream::Client.new
    client.userstream do |status|
      next if status.text =~ /RT|@(.*)/
      puts "#{status.user.screen_name}: #{status.text}" # debug
      @staff.write(
        "type"   => "note",
        "status" => {
          "id"               => status.id,
          "user.screen_name" => status.user.screen_name,
          "text"             => status.text,
          "created_at"       => status.created_at,
        },
        "created_at" => Time.now
      )
    end
  end
end
