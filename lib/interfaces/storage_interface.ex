defmodule ImgOut.StorageInterface do
  @moduledoc """
  An interface module for IO on Remote Storage.
  """

  @callback read({:ok, binary}) :: {:ok, binary}
  @callback read({:error, integer, map}) :: {:error, integer, map}
  @callback read(charlist) :: {:ok, binary} | {:error, integer, map}
end
