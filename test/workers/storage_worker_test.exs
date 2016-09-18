defmodule ImgOut.StorageWorkerTest do
  use ExUnit.Case, async: true
  import Mock
  alias ImgOut.StorageWorker, as: Storage

  @id "elixir.png"
  @base_url Application.get_env(:imgout, :remote_storage_url)

  setup do
    Memcache.Client.flush
    {:ok, []}
  end

  test "return file content if remote file exists" do
    uri = "#{@base_url}/#{@id}"
    file_content = File.read!("./test/fixtures/#{@id}")
    with_mock HTTPoison, [get!: fn(uri) ->
      %HTTPoison.Response{status_code: 200, body: file_content} end] do
      {:ok, response} = Storage.read(@id)
      assert called HTTPoison.get!(uri)
      assert is_binary(response)
    end
  end

  test "return error if remote file not exists" do
    uri = "#{@base_url}/#{@id}"
    with_mock HTTPoison, [get!: fn(uri) ->
      %HTTPoison.Response{status_code: 404, body: "Not found"} end] do
      response = Storage.read(@id)
      assert called HTTPoison.get!(uri)
      assert response == {:error, 404, %{page: "Not found!"}}
    end
  end
end
