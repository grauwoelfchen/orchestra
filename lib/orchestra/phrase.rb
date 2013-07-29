# encoding: utf-8

require "drb"
require "rinda/tuplespace"
require "net/http"
require "uri"
require "json"

class Phrase
  def initialize(staff)
    @staff = staff
    @retry = 3
  end

  def main_loop
    loop do
      begin
        tuple = @staff.take({"type" => "note", "status" => nil, "created_at" => nil})
        phrase = extract(tuple["status"])
        record(phrase)
      rescue Rinda::RequestExpiredError
        # pass
      rescue DRb::DRbConnError
        if @retry > 0
          @retry -= 1
          sleep 10
        else
          raise
        end
      end
    end
  end

  private

  def extract(status)
    base = "http://jlp.yahooapis.jp/KeyphraseService/V1/extract?output=json"
    sentence = URI.escape(status["text"])
    uri = URI.parse("#{base}&appid=#{ENV["YAHOO_APPLICATION_ID"]}&sentence=#{sentence}")
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end

  def record(phrase)
    puts phrase # debug
    unless phrase.empty?
      @staff.write(
        "type"       => "phrase",
        "status"     => phrase,
        "created_at" => Time.now
      )
    end
  end
end
