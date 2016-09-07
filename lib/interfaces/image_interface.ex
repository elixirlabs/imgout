defmodule ImgOut.ImageInterface do
  @moduledoc """
  An interface module for image processing.
  """

  @callback thumb({:error, integer, map}, any) :: {:error, integer, map}
  @callback thumb(binary, map) :: {:ok, binary} | {:error, integer, map}
end
