defmodule ImgOut.Plug.Metric do
  alias Metrex.Counter
  alias Metrex.Meter
  alias Plug.Conn

  @doc false
  def init(opts),
    do: {Keyword.get(opts, :name, ""), Keyword.get(opts, :pattern, "")}

  @doc false
  def call(conn, {name, pattern}) do
    if is_nil(pattern) || Regex.match?(pattern, conn.request_path) do
      start_all(name)
      Counter.increment(name <> ".total")
      Counter.increment(name <> ".active")
      Conn.register_before_send(conn, fn conn ->
        Counter.increment(name <> ".succeed")
        Counter.decrement(name <> ".active")
        Meter.increment(metric_name(name, conn.status))
        conn
      end)
    else
      conn
    end
  end

  @doc false
  def handle_error(conn, {name, pattern}) do
    if Regex.match?(pattern, conn.request_path) do
      Counter.increment(name <> ".failed")
      Counter.decrement(name <> ".active")
      Meter.increment(metric_name(name, conn.status))
    end
  end

  defp start_all(metric) do
    if is_nil(Process.whereis(:"counter.#{metric}.total")) do
      counter_plugs = Enum.each(plug_counters(metric), fn(counter) ->
        Metrex.start_counter(counter) end
      )

      meter_plugs = Enum.each(plug_meters(metric), fn(meter) ->
        Metrex.start_meter(meter) end
      )
    end
  end

  defp plug_counters(metric) do
    [metric <> ".total", metric <> ".active",
      metric <> ".succeed", metric <> ".failed"]
  end

  defp plug_meters(metric),
    do: plug_meters([], metric)
  defp plug_meters(meters, metric) do
    Enum.reduce([500, 200], meters, fn(status, meters) ->
      [metric_name(metric, status) | meters] end)
  end

  defp metric_name(metric, status) do
    case status do
      s when s >= 500 -> metric <> ".server_error"
      200 -> metric <> ".ok"
      _ -> metric <> ".other"
    end
  end
end
