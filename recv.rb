#!/usr/bin/env ruby
# require 'pry'

@in = STDIN.read
puts "++file recd on server: \n#{@in}"

if File.exists?(ARGF.filename)
  File.open(ARGF.filename, 'a+') { |f| f.write(@in) }

  puts "++existing file written from server."
else
  File.open(ARGF.filename, 'a+') { |f| f.write(@in) }

  puts "++new file created and written from server."
end
