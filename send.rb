# #!/usr/bin/env ruby
require 'byebug'
require 'zlib'
require 'digest'

class Send
  DIGEST_SIZE = 32
  LENGTH_SIZE = 4
  CHUNK_SIZE = 1024

  def initialize
    @in_file = ARGF.file
  end

  def transfer
    chunks(@in_file).each do |chunk|
      # puts line.sum
      STDOUT.write(Digest::MD5.hexdigest(chunk))
      compressed_chunk = Zlib::Deflate.deflate(chunk)

      STDOUT.write(chunk.length.to_s.split.pack("A#{LENGTH_SIZE}"))
      STDOUT.write(compressed_chunk.length.to_s.split.pack("A#{LENGTH_SIZE}"))



      if STDIN.read(1) == "y"
        STDOUT.write(compressed_chunk)
      end
    end
  end

  def chunks(str)
    chunks = []
    until str.eof?
      chunk = str.read(CHUNK_SIZE)
      chunks << chunk
    end
    chunks
  end
end

Send.new.transfer
