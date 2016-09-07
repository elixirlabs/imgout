defmodule ImgOut.CacheServiceTest do
  use ExUnit.Case, async: true
  alias ImgOut.CacheService

  @key "some_key"
  @new_key "new_key"

  test "read with valid key" do
    Memcache.Client.set(@key, "some_val")
    assert CacheService.read(@key) == {:ok, "some_val"}
  end

  test "read with invalid key" do
    Memcache.Client.delete(@new_key)
    assert CacheService.read(@new_key) == @new_key
  end

  test "write with key and value" do
    Memcache.Client.delete(@new_key)
    assert CacheService.write(@new_key, "new_val") == {:ok, "new_val"}
  end
end
