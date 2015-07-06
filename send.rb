# #!/usr/bin/env ruby

# STDOUT.write(ARGF.read)
# STDERR.puts "\n--file sent from client..."
require 'byebug'

class Send
  def initialize
    @in_file = ARGF.read
  end

  def transfer
    @in_file.each_line do |line|
      puts line.sum

      if STDIN.read(1) == "y"
        STDOUT.write(line)
      end
    end
  end
end

Send.new.transfer
