defmodule ImgOut.MicroserviceWorkerTest do
  use ExUnit.Case, async: true
  use Plug.Test
  import Mock
  alias ImgOut.MicroserviceWorker, as: Microservice
  alias ImgOut.ThumbMicroservice, as: ThumbMicroservice

  @opts Microservice.init([])
  @id "elixir.png"
  @file_content File.read!("./test/fixtures/#{@id}")

  setup do
    {:ok, conn: conn(:get, "/", nil)}
  end

  test "a :GET to /:id/:dimensions with exisiting id and valid dimensions", %{conn: conn} do
    dimensions = "128x128"
    with_mock ThumbMicroservice, [process: fn(@id, dimensions) ->
      {:ok, @file_content, "image/png"} end] do
      conn = conn(:get, "/#{@id}/#{dimensions}")
      conn = Microservice.call(conn, @opts)

      assert called ThumbMicroservice.process(@id, dimensions)
      assert conn.state == :sent
      assert conn.status == 200
      assert is_binary(conn.resp_body)
    end
  end

  test "a :GET to /:id/:dimensions with exisiting id and invalid dimensions", %{conn: conn} do
    dimensions = "x"
    conn = conn(:get, "/#{@id}/#{dimensions}")
    conn = Microservice.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 422
    assert is_binary(conn.resp_body)
  end

  test "a :GET to /:id/:dimensions with non-exisiting id", %{conn: conn} do
    dimensions = "128x128"
    with_mock ThumbMicroservice, [process: fn(@id, dimensions) ->
      {:error, 404, %{page: "Not found."}} end] do
      conn = conn(:get, "/#{@id}/#{dimensions}")
      conn = Microservice.call(conn, @opts)

      assert called ThumbMicroservice.process(@id, dimensions)
      assert conn.state == :sent
      assert conn.status == 404
      assert is_binary(conn.resp_body)
    end
  end

  test "a :GET to /unknown", %{conn: conn} do
    conn = conn(:get, "/unknown")
    conn = Microservice.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "{\"errors\":{\"page\":\"Not found!\"}}"
  end
end
