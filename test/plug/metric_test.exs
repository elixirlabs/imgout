defmodule ImgOut.Plug.MetricTest do
  use ExUnit.Case
  import Plug.Conn
  import Plug.Test
  alias Plug.Conn
  alias ImgOut.Plug.Metric

  setup do
    {:ok, conn: build_conn(:get, "/", nil)}
  end

  test "counters and metrics are counting", %{conn: conn} do
    conn = Metric.call(conn, {"thumb", ~r/(^\/thumb)/})
    refute is_nil(Process.whereis(:"counter.thumb.active"))
    refute is_nil(Process.whereis(:"counter.thumb.succeed"))
    refute is_nil(Process.whereis(:"counter.thumb.failed"))
    refute is_nil(Process.whereis(:"counter.thumb.total"))
    refute is_nil(Process.whereis(:"meter.thumb.ok"))
    refute is_nil(Process.whereis(:"meter.thumb.server_error"))
  end

  defp build_conn(method, path, params_or_body \\ nil),
    do: Plug.Adapters.Test.Conn.conn(%Conn{}, method, path, params_or_body)
end
