#!/usr/bin/env ruby
require 'stringio'
require 'byebug'
require 'zlib'
require 'digest'

class Recv
  DIGEST_SIZE = 32
  LENGTH_SIZE = 4
  CHUNK_SIZE = 1024

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
    recd_bytes = 0

    until STDIN.eof?
      new_digest = STDIN.read(DIGEST_SIZE)
      uncompressed_new_chunk_length = STDIN.read(LENGTH_SIZE).to_i
      compressed_new_chunk_length = STDIN.read(LENGTH_SIZE).to_i

      recd_bytes += DIGEST_SIZE + (LENGTH_SIZE * 2)
      # STDERR.puts "\nnew new_digest, length: #{new_digest.bytes.size}, digest: #{new_digest}"

      unless (old_chunk = @old_output.read(uncompressed_new_chunk_length))
        old_chunk = ""
      end

      old_digest = Digest::MD5.hexdigest(old_chunk)
      # STDERR.puts "old digest, length: #{old_digest.bytes.size}, Digest: #{old_digest}\n"

      if new_digest == old_digest
        STDOUT.write("n")

        @new_output.write(old_chunk)

        # STDERR.puts "Wrote OLD chunk: #{old_chunk.size}"
      else
        STDOUT.write("y")

        compressed_new_chunk = STDIN.read(compressed_new_chunk_length)
        recd_bytes += compressed_new_chunk_length

        uncompressed_new_chunk = Zlib::Inflate.inflate(compressed_new_chunk)
        @new_output.write(uncompressed_new_chunk)

        # STDERR.puts "Wrote NEW chunk: #{new_chunk.size}"
      end
    end

    STDERR.puts "Recd #{recd_bytes} Bytes"
    STDERR.puts "Recd #{recd_bytes / 1000000.00} MB"

    @old_output.close
    @new_output.close
  end
end

recv = Recv.new.receive
