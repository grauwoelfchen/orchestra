# encoding: utf-8

require "drb"
require "rinda/tuplespace"
require "net/http"
require "uri"
require "json"
require "orchestra/concerns/concertable"

class Phrase
  include Concertable

  def initialize(staff)
    @staff = staff
  end

  def main_loop
    loop do
      tuple = perform do
        @staff.take({"type" => "note", "status" => nil, "created_at" => nil})
      end
      phrase = extract(tuple)
      perform do
        record(phrase, @staff)
      end
    end
  end

  private

  def extract(tuple)
    return unless tuple.is_a? Hash
    status = tuple["status"]
    # TODO
    # add error handling
    base = "http://jlp.yahooapis.jp/KeyphraseService/V1/extract?output=json"
    sentence = URI.escape(status["text"])
    begin
      uri = URI.parse("#{base}&appid=#{ENV["YAHOO_APPLICATION_ID"]}&sentence=#{sentence}")
      response = Net::HTTP.get(uri)
    rescue Net::HTTPForbidden
    end
    JSON.parse(response)
  end

  def record(phrase, staff)
    puts phrase # debug
    staff.write(
      "type"       => "phrase",
      "status"     => phrase,
      "created_at" => Time.now
    ) unless phrase.empty?
  end
end
