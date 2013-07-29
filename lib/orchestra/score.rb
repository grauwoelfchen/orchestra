# encoding: utf-8

require "drip"

class Score < Drip
  def quit
    Thread.new do
      synchronize do
        exit 0
      end
    end
  end
end
