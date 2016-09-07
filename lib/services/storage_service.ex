defmodule ImgOut.StorageService do
  @moduledoc """
  An implementation module of StorageInterface for remote storage.
  """

  alias ImgOut.CacheWorker, as: Cache

  @behaviour ImgOut.StorageInterface
  @base_url Application.get_env(:imgout, :remote_storage_url)

  @doc """
  Read file from remote URI
  """
  def read(id) do
    id
    |> Cache.read
    |> read_remote
  end

  defp read_remote({:ok, binary}),
    do: {:ok, binary}
  defp read_remote({:error, status, map}),
    do: {:error, status, map}
  defp read_remote(id) do
    case HTTPoison.get!("#{@base_url}/#{id}") do
      %HTTPoison.Response{body: img, status_code: 200} -> Cache.write(id, img)
      %HTTPoison.Response{body: _, status_code: 404} -> remote_file_not_found
      _ -> remote_storage_error

    end
  end

  defp remote_file_not_found,
    do: {:error, 404, %{page: "Not found!"}}

  defp remote_storage_error,
    do: {:error, 503, %{remote: "Remote storage service unavailable."}}
end
