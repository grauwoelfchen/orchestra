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
      interval = Time.now + 60 * 10
      buffers = []
      while Time.now < interval do
        buffers << perform do
          @staff.take({"type" => "phrase", "status" => nil, "created_at" => nil})
        end
        print "#{buffers.length}\r" # debug
      end
      movement = beat(buffers)
      perform do
        record(movement, @score)
      end if movement
    end
  end

  private

  def beat(buffers)
    puts "buffers.length #=> #{buffers.length}" # debug
    unless buffers.empty?
      movement = buffers.map{|phrase| phrase["status"] }.inject {|m, e| m.merge(e) {|k, o, n| o + n } }
      Hash[movement.sort { |a, b| b[1] <=> a[1] }]
    end
  end

  def record(movement, score)
    score.write([movement, Time.now])
  end
end
