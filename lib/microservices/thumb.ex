defmodule ImgOut.ThumbMicroservice do
  @moduledoc """
  Thumb microservice
  """

  alias ImgOut.StorageWorker, as: Storage
  alias ImgOut.ImageWorker, as: Image

  @doc """
  Fetches remote image from remote storage, caches it. Then generates thumbnail
  for given dimensions.


  """
  def process(_, "x"),
    do: {:error, 422, %{dimensions: "Invalid dimension format. Tip: {w}x{h}"}}
  def process(id, dimensions) do
    gen_thumb(id,
      Regex.named_captures(~r/(^(?<width>\d*)x(?<height>\d*)$)/, dimensions))
  end

  defp gen_thumb(_, nil),
    do: {:error, 422, %{dimensions: "Invalid dimension format. Tip: {w}x{h}"}}
  defp gen_thumb(id, %{"width" => "", "height" => height}),
    do: gen_thumb(id, %{height: height})
  defp gen_thumb(id, %{"width" => width, "height" => ""}),
    do: gen_thumb(id, %{width: width})
  defp gen_thumb(id, %{"width" => width, "height" => height}),
    do: gen_thumb(id, %{width: width, height: height})
  defp gen_thumb(id, %{} = dimensions) do
    id
    |> Storage.read
    |> Image.thumb(dimensions)
  end
end
