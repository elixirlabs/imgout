defmodule ImgOut.ImageService do
  @moduledoc """
  An implementation module of ImageInterface for image processing.
  """

  @behaviour ImgOut.ImageInterface

  @doc """
  Generate thumnail from given binary image and dimensions

  ## Examples

      ImgOut.ImageService.thumb({:ok, File.read("x.png")}, %{width: 128})

      ImgOut.ImageService.thumb({:ok, File.read("x.png")}, %{height: 128})

      ImgOut.ImageService.thumb({:ok, File.read("x.png")}, %{width: 128,
        height: 128})
  """
  def thumb({:ok, img}, dimensions) do
    {img, format} =
      ExMagick.init!
      |> ExMagick.image_load!({:blob, img})
      |> (&(gen_thumb(&1, ratio(ExMagick.size!(&1)), dimensions))).()
      |> (&({ExMagick.image_dump!(&1), ExMagick.attr!(&1, :magick)})).()
    {:ok, img, content_type(format)}
  end
  def thumb({:error, status, reason}, _),
    do: {:error, status, reason}

  defp gen_thumb(img, _, %{width: width, height: height}) when is_integer(width) and is_integer(height),
    do: ExMagick.thumb!(img, width, height)
  defp gen_thumb(img, _, %{width: width, height: height}) when is_binary(width) and is_binary(height),
    do: ExMagick.thumb!(img, to_int(width), to_int(height))
  defp gen_thumb(img, ratio, %{width: width}),
    do: gen_thumb(img, ratio, %{width: to_int(width), height: round(to_int(width) * ratio)})
  defp gen_thumb(img, ratio, %{height: height}),
    do: gen_thumb(img, ratio, %{width: round(to_int(height) / ratio), height: to_int(height)})

  defp ratio(dimensions),
    do: dimensions.width / dimensions.height

  defp to_int(str),
    do: String.to_integer(str)

  defp content_type(format),
    do: "image/" <> String.downcase(format)
end
