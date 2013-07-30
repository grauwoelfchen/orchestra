# encoding: utf-8

require "drb"
require "rinda/tuplespace"
require "net/http"

module Concertable
  def retrievable?
    if @retry > 0
      @retry -= 1
      true
    else
      false
    end
  end

  def perform
    restart
    begin
      yield
    rescue Rinda::RequestExpiredError # tuplespace
      nil
    rescue Net::HTTPForbidden # net
      nil
    rescue DRb::DRbConnError,
           Net::HTTPServerError
      retrievable? ? sleep(10) : raise
    end
  end

  def restart
    @retry = 3
  end
end
