#!/usr/bin/env ruby
require 'stringio'
require 'byebug'
require 'zlib'
require 'digest'

class Recv
  DIGEST_SIZE = 32
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
      recd_bytes += new_digest.bytes.size
      # STDERR.puts "\nnew new_digest, length: #{new_digest.bytes.size}, digest: #{new_digest}"

      unless (old_chunk = @old_output.read(CHUNK_SIZE))
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

        new_chunk = STDIN.read(CHUNK_SIZE)
        @new_output.write(new_chunk)
        recd_bytes += new_chunk.bytes.size

        # STDERR.puts "Wrote NEW chunk: #{new_chunk.size}"
      end
    end

    STDERR.puts recd_bytes

    @old_output.close
    @new_output.close
  end
end

recv = Recv.new.receive
