# encoding: utf-8

require "rinda/tuplespace"
require "orchestra/concerns/concertable"

class Baton
  include Concertable

  def initialize(staff, score)
    @staff = staff
    @score = score
  end

  def main_loop
    loop do
      interval = tempo
      buffers = []
      while Time.now < interval do
        phrase = perform do
          @staff.take({"type" => "phrase", "status" => nil}, 0)
        end
        if phrase
          buffers << phrase
          print "#{buffers.length}\r" # debug
        end
      end
      movement = beat(buffers)
      perform do
        record(movement, @score)
      end
    end
  end

  private

  def tempo
    Time.now + 60 * 10
  end

  def beat(buffers)
    puts Time.now # debug
    puts "buffers.length #=> #{buffers.length}" # debug
    return nil if buffers.empty?
    movement = buffers.map {|b| b["status"] }.inject {|m,e| m.merge(e) {|_,o,n| o + n } }
    movement = filter(movement)
    Hash[movement.sort { |a,b| b[1] <=> a[1] }]
  end

  def filter(movement)
    movement.reject{|k,v| !v.is_a?(Fixnum) }
  end

  def record(movement, score)
    return unless movement
    score.write([movement, Time.now], 'movement')
  end
end
