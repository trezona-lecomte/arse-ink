#!/usr/bin/env ruby
puts "++running server..."

@in = STDIN.read
puts "++file recd on server: \n#{@in}"

begin
  ARGF.each do |file|
    File.open(file, 'a+') { |f| f.write(@in) }
    puts "++existing file written from server."
  end
rescue Errno::ENOENT
  File.open(ARGF.filename, 'a+') { |f| f.write(@in) }
  puts "++new file created and written from server."
end
