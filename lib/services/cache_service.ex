defmodule ImgOut.CacheService do
  @moduledoc """
  An implementation module of CacheInterface for cache handling.
  """

  @behaviour ImgOut.CacheInterface

  def read(key) do
    response = Memcache.Client.get(key)
    case response.status do
      :ok -> {:ok, response.value}
      _ -> key
    end
  end

  def write(key, val) do
    Memcache.Client.set(key, val)
    {:ok, val}
  end
end
