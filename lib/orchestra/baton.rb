# encoding: utf-8

require "rinda/tuplespace"

class Baton
  def initialize(staff, score)
    @staff = staff
    @score = score
    @buffers = []
  end

  def main_loop
    loop do
      interval = Time.now + 60 * 10
      while Time.now < interval do
        begin
          @buffers << @staff.take({"type" => "phrase", "status" => nil, "created_at" => nil})
          print "#{@buffers.length}\r"
        rescue Rinda::RequestExpiredError
          # pass
        end
      end
      movement = beat(@buffers)
      @buffers.clear
      record(movement, @score) if movement
    end
  end

  private

  def beat(buffers)
    puts "buffers.length #=> #{buffers.length}" # debug
    unless buffers.empty?
      movement = buffers.map{|phrase| phrase["status"] }.inject {|m, e| m.merge(e) }
      begin
      Hash[movement.sort { |a, b| b[1] <=> a[1] }]
      rescue ArgumentError
        require "pry"
        binding.pry
      end
    end
  end

  def record(movement, score)
    score.write([movement, Time.now])
  end
end
