# encoding: utf-8

require "drb"
require "tweetstream"
require "orchestra/concerns/concertable"

class Stream
  include Concertable

  def initialize(staff, acoustic)
    @staff = staff
    @acoustic = acoustic
    configure
  end

  def main_loop
    client = TweetStream::Client.new
    client.userstream do |status|
      next if status.text =~ /RT|@(.*)/
      puts "#{status.user.screen_name}: #{status.text}" # debug
      tweet = tuple(status)
      record(tweet, @staff) && track(tweet, @acoustic)
    end
  end
  
  private

  def configure
    TweetStream.configure do |config|
      config.consumer_key       = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret    = ENV["TWITTER_CONSUMER_SECRET"]
      config.oauth_token        = ENV["TWITTER_ACCESS_TOKEN"]
      config.oauth_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
      config.auth_method        = :oauth
    end
  end

  def tuple(status)
    begin
      {
        "type"   => "note",
        "status" => {
          "id"               => status.id,
          "user.screen_name" => status.user.screen_name,
          "text"             => status.text,
          "created_at"       => status.created_at,
        },
        "created_at" => Time.now
      }
    rescue StandardError
      {}
    end
  end

  def record(tweet, staff)
    perform do
      staff.write(tweet) unless tweet.empty?
    end
  end

  def track(tweet, acoustic)
    perform do
      acoustic.write(tweet) unless tweet.empty?
    end
  end
end
