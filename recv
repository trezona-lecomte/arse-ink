#!/usr/bin/env ruby
require 'stringio'
require 'byebug'

class Recv
  MB = 4

  def initialize
    begin
      @old_output = StringIO.new(ARGF.read)
      @new_output = File.open(ARGF.filename, "w+")
    rescue Errno::ENOENT
      @old_output = StringIO.new
      @new_output = File.open(ARGF.filename, "w")
    end
  end

  def receive
    until STDIN.eof?
      new_sum = STDIN.readline.to_i

      begin
        old_line = @old_output.readline
      rescue EOFError
        old_line = ""
      end

      old_sum = old_line.sum

      if new_sum.to_i == old_sum.to_i
        STDOUT.write("n")

        @new_output.write(old_line)

        STDERR.puts "Wrote OLD line: #{old_line}"
      else
        STDOUT.write("y")

        new_line = STDIN.readline
        @new_output.write(new_line)

        STDERR.puts "Wrote NEW line: #{new_line}"
      end
    end

    @old_output.close
    @new_output.close
  end
end

recv = Recv.new.receive

    # until !(new_chunk = STDIN.read(MB))
    #   existing_chunk = @output.read(MB)

    #   puts STDIN.read(MB).sum

    #   if new_chunk == existing_chunk
    #     puts existing_chunk
    #   else
    #     puts new_chunk
    #   end
    # end
      # puts chunk
      # chunk = STDIN.read(4)
  # end
      # File.open(@out_file, "a+") do |file|
      #   file.write(STDIN.read)
      # end
    # end
    # until STDIN.eof?
    #   STDIN.each_byte do |byte|
    #     puts byte
    #   end
    # end
# end

#   def save_file
#     if File.exists?(@out)
#       File.open(@out, 'a+') { |f| f.write(@in.read) }

#       puts "++existing file written from server."
#     else
#       File.open(@out, 'a+') { |f| f.write(@in.read) }

#       puts "++new file created and written from server."
#     end
#   end
# end

# server = Server.new(output: "local-file.txt")
# server.send(input: StringIO.new("testing!!!"))

# server.save_file

