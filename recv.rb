#!/usr/bin/env ruby
require 'stringio'
require 'byebug'

class Server
  def initialize(input:, output: ARGF.filename)
    @in = input
    @out = output
    # byebug
  end

  def save_file
    if File.exists?(@out)
      File.open(@out, 'a+') { |f| f.write(@in) }

      puts "++existing file written from server."
    else
      File.open(@out, 'a+') { |f| f.write(@in) }

      puts "++new file created and written from server."
    end
  end
end

server = Server.new(input: "testing!!!", output: "local-file.txt")

server.save_file
