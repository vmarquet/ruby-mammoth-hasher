require 'test/unit'
require 'digest'
require 'mammoth-hasher'

class MammothHasherTest < Test::Unit::TestCase
  # for small files, instead of using our custom algorithm,
  # it's simpler to use the md5 hash directly,
  # so here we test that MammothHasher hash is the same than md5 hash
  def test_small_file_hash
    filename = "test/fixtures/small.txt"
    file = File.open(filename, 'r')
    assert_equal MammothHasher.hash(filename), Digest::MD5.file(file).hexdigest
  end

  def test_hash_size
    filename = "test/fixtures/large.txt"
    assert_equal MammothHasher.hash(filename).length, 32
  end

  def test_hash_result
    filename = "test/fixtures/large.txt"
    assert_equal MammothHasher.hash(filename), "d5d198a347f02adafa6e1749ad594340"
  end
end
