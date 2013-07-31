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
      tuple = read(@staff)
      phrase = extract(tuple)
      record(phrase, @staff)
    end
  end

  private

  def read(staff)
    perform do
      staff.take({"type" => "note", "status" => nil})
    end
  end

  def extract(tuple)
    return nil unless tuple.is_a?(Hash)
    status = tuple["status"]
    base = "http://jlp.yahooapis.jp/KeyphraseService/V1/extract?output=json"
    sentence = URI.escape(status["text"])
    unless sentence.empty?
      uri = URI.parse("#{base}&appid=#{ENV["YAHOO_APPLICATION_ID"]}&sentence=#{sentence}")
      perform do
        response = Net::HTTP.get(uri)
        result = JSON.parse(response)
        return nil if result.empty? # no phrase
        if result.is_a?(Hash) && \
           result.values.reject{|e| e.is_a?(Fixnum) }.empty?
          result
        else
          puts "Error : #{result}" # debug
          nil
        end
      end
    end
  end

  def record(phrase, staff)
    return unless phrase
    puts phrase # debug
    perform do
      staff.write(
        "type"   => "phrase",
        "status" => phrase,
      ) unless phrase.empty?
    end
  end
end
