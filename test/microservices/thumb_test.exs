defmodule ImgOut.ThumbMicroserviceTest do
  use ExUnit.Case, async: true
  import Mock
  alias ImgOut.ThumbMicroservice, as: ThumbMicroservice
  alias ImgOut.StorageWorker, as: Storage

  @id "elixir.png"
  @file_content File.read!("./test/fixtures/#{@id}")

  setup do
    Memcache.Client.flush
    :ok
  end

  test "process with exisiting id and valid width x height" do
    with_mock Storage, [read: fn(@id) -> {:ok, @file_content} end] do
      {:ok, img, content_type} = ThumbMicroservice.process(@id, "128x256")
      assert called Storage.read(@id)
      refute is_nil(img)
      refute is_nil(content_type)
    end
  end

  test "process with exisiting id and valid width x nil height" do
    with_mock Storage, [read: fn(@id) -> {:ok, @file_content} end] do
      {:ok, img, content_type} = ThumbMicroservice.process(@id, "128x")
      assert called Storage.read(@id)
      refute is_nil(img)
      refute is_nil(content_type)
    end
  end

  test "process with exisiting id and nil width x valid height" do
    with_mock Storage, [read: fn(@id) -> {:ok, @file_content} end] do
      {:ok, img, content_type} = ThumbMicroservice.process(@id, "x128")
      assert called Storage.read(@id)
      refute is_nil(img)
      refute is_nil(content_type)
    end
  end

  test "process with exisiting id and nil width x nil height" do
    {:error, status, reason} = ThumbMicroservice.process(@id, "x")
    refute is_nil(status)
    refute is_nil(reason)
  end

  test "process /:id/:dimensions with exisiting id and invalid dimensions" do
    {:error, status, reason} = ThumbMicroservice.process(@id, "unknown")
    refute is_nil(status)
    refute is_nil(reason)
  end

  test "process /:id/:dimensions with non-exisiting id" do
    with_mock Storage, [read: fn(@id) -> {:error, 404, %{page: "404"}} end] do
      {:error, status, reason} = ThumbMicroservice.process(@id, "128x128")
      refute is_nil(status)
      refute is_nil(reason)
    end
  end
end
