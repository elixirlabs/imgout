defmodule ImgOut.CacheInterface do
  @moduledoc """
  An interface module for cache handling.
  """

  @callback read(charlist) :: {:ok, binary} | charlist
  @callback write(charlist, binary) :: {:ok, binary}
end
