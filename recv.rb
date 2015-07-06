#!/usr/bin/env ruby
require 'stringio'
require 'byebug'
require 'zlib'
require 'digest'

class Recv
  DIGEST_SIZE = 16
  LENGTH_SIZE = 4
  CHUNK_SIZE = 512

  def initialize
    # @recd_bytes = 0
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
      read_header

      @old_chunk = read_old_chunk

      if @new_digest == Digest::MD5.hexdigest(@old_chunk).to_s
        STDOUT.write("n")

        @new_output.write(@old_chunk)
      else
        STDOUT.write("y")

        @new_output.write(read_new_chunk)
      end
    end
    # STDERR.puts "Recd #{@recd_bytes} Bytes"
    # STDERR.puts "Recd #{@recd_bytes / 1000000.00} MB"
    @old_output.close
    @new_output.close
  end

  private

  def read_header
    @new_digest = STDIN.read(DIGEST_SIZE).unpack('H32').first
    @uncompressed_new_chunk_length = STDIN.read(LENGTH_SIZE).to_i
    @compressed_new_chunk_length = STDIN.read(LENGTH_SIZE).to_i
    # @recd_bytes += DIGEST_SIZE + (LENGTH_SIZE * 2)
  end

  def read_old_chunk
    unless (old_chunk = @old_output.read(@uncompressed_new_chunk_length))
      old_chunk = ""
    end

    @old_chunk = old_chunk
  end

  def read_new_chunk
    compressed_new_chunk = STDIN.read(@compressed_new_chunk_length)
    # @recd_bytes += @compressed_new_chunk_length
    Zlib::Inflate.inflate(compressed_new_chunk)
  end
end

recv = Recv.new.receive
