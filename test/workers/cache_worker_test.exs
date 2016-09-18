defmodule ImgOut.CacheWorkerTest do
  use ExUnit.Case, async: true
  alias ImgOut.CacheWorker, as: Cache

  @key "some_key"
  @new_key "new_key"

  test "read with valid key" do
    Memcache.Client.set(@key, "some_val")
    assert Cache.read(@key) == {:ok, "some_val"}
  end

  test "read with invalid key" do
    Memcache.Client.flush
    assert Cache.read(@new_key) == @new_key
  end

  test "write with key and value" do
    Memcache.Client.delete(@new_key)
    assert Cache.write(@new_key, "new_val") == {:ok, "new_val"}
  end
end
