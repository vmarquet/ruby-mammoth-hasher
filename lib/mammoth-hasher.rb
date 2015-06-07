require 'digest'  # needed for the md5 hash algorithm

class MammothHasher
  def self.hash filename, debug=false
    time_start = Time.now if debug

    # we check that the file exist
    raise ArgumentError, "give the filename as a parameter (got nil)" if filename == nil
    raise ArgumentError, "filename must be a string" if ! filename.is_a? String
    filename = File.expand_path filename
    raise ArgumentError, "#{filename} does not exist" if ! File.exist? filename

    # algorithm parameters
    # WARNING: if you change them, the resulting hash will be different !
    number_of_chunks = 100
    length_of_chunks = 4

    # we get the file size (in bytes), used as PRNG (Pseudo Random Number Generator)
    filesize = File.size filename

    # if the file is not a big file, it's quicker to compute
    # the MD5 of the whole file than to apply our custom algorithm
    if filesize <= number_of_chunks*length_of_chunks
      file = File.open(filename, 'r')
      hash = Digest::MD5.file(file).hexdigest
      file.close
      puts (Time.now - time_start).to_s + " seconds" if debug
      return hash
    end

    # we initialize the PRNG
    prng = Random.new filesize

    # we always get a chunk at the offset 0 (beginning of file)
    # because that's where the magic number indicating the file type is
    # so making sure that it's still the same may prevent from some attacks
    offsets = [0]

    # we get 99 other offsets between 0 and (filesize - length_of_chunk)
    for i in 1..(number_of_chunks-1)
      offsets << prng.rand(filesize - length_of_chunks)
    end

    # we sort the offsets in ascending order
    # (in order to optimize the way the file will be read (in only one direction))
    offsets.sort

    # we concatenate all the bytes from all the chunks at the offset we choose
    bytes = ""
    for offset in offsets
      bytes = "#{bytes}#{File.read(filename, length_of_chunks, offset)}"
    end

    # we compute the final hash, which is the hash of the concatenation of all chunks
    hash = Digest::MD5.new.hexdigest bytes

    puts (Time.now - time_start).to_s + " seconds" if debug

    return hash
  end
end