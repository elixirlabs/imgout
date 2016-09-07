defmodule ImgOut.ServerWorkerTest do
  use ExUnit.Case, async: true
  use Plug.Test
  import Mock
  alias ImgOut.ServerWorker, as: Server

  @opts Server.init([])
  @id "1233456609X"
  @base_url Application.get_env(:imgout, :remote_storage_url)
  @file_content File.read!("./test/fixtures/elixir.png")

  setup do
    Memcache.Client.flush
    conn = build_conn()
           |> put_req_header("accept", "image/*")
    {:ok, conn: conn}
  end

  def build_conn() do
    conn(:get, "/", nil)
  end

  test "a :GET to /:id/:dimensions with exisiting id and valid width x height", %{conn: conn} do
    uri = "#{@base_url}/#{@id}"
    with_mock HTTPoison, [get!: fn(uri) ->
      %HTTPoison.Response{status_code: 200, body: @file_content} end] do
      conn = conn(:get, "/#{@id}/128x256")
      conn = Server.call(conn, @opts)

      assert called HTTPoison.get!(uri)
      assert conn.state == :sent
      assert conn.status == 200
      assert is_binary(conn.resp_body)
    end
  end

  test "a :GET to /:id/:dimensions with exisiting id and valid width x nil height", %{conn: conn} do
    uri = "#{@base_url}/#{@id}"
    with_mock HTTPoison, [get!: fn(uri) ->
      %HTTPoison.Response{status_code: 200, body: @file_content} end] do
      conn = conn(:get, "/#{@id}/128x")
      conn = Server.call(conn, @opts)

      assert called HTTPoison.get!(uri)
      assert conn.state == :sent
      assert conn.status == 200
      assert is_binary(conn.resp_body)
    end
  end

  test "a :GET to /:id/:dimensions with exisiting id and nil width x valid height", %{conn: conn} do
    uri = "#{@base_url}/#{@id}"
    with_mock HTTPoison, [get!: fn(uri) ->
      %HTTPoison.Response{status_code: 200, body: @file_content} end] do
      conn = conn(:get, "/#{@id}/x256")
      conn = Server.call(conn, @opts)

      assert called HTTPoison.get!(uri)
      assert conn.state == :sent
      assert conn.status == 200
      assert is_binary(conn.resp_body)
    end
  end

  test "a :GET to /:id/:dimensions with exisiting id and nil width x nil height", %{conn: conn} do
    conn = conn(:get, "/#{@id}/x")
    conn = Server.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 422
    assert is_binary(conn.resp_body)
  end

  test "a :GET to /:id/:dimensions with exisiting id and invalid dimensions", %{conn: conn} do
    conn = conn(:get, "/#{@id}/unknown")
    conn = Server.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 422
    assert is_binary(conn.resp_body)
  end

  test "a :GET to /:id/:dimensions with non-exisiting id", %{conn: conn} do
    uri = "#{@base_url}/#{@id}"
    with_mock HTTPoison, [get!: fn(uri) ->
      %HTTPoison.Response{status_code: 404, body: "Not found"} end] do
      conn = conn(:get, "/#{@id}/256x256")
      conn = Server.call(conn, @opts)

      assert called HTTPoison.get!(uri)
      assert conn.state == :sent
      assert conn.status == 404
      assert is_binary(conn.resp_body)
    end
  end

  test "a :GET to /unknown", %{conn: conn} do
    conn = conn(:get, "/unknown")
    conn = Server.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "{\"errors\":{\"page\":\"Not found!\"}}"
  end
end
