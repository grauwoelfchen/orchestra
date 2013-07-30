# encoding: utf-8

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
    rescue Rinda::RequestExpiredError
      # pass
    rescue DRb::DRbConnError
      retrievable? ? sleep(10) : raise
    end
  end

  def restart
    @retry = 3
  end
end
