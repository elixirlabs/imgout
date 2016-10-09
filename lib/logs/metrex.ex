defmodule Imgout.Logger.Metrex do
  use Metrex.Hook
  require Logger

  @doc """
  Default hook on `Metrex.Counter` exit
  """
  def counter_exit(reason, metric, val) do
    Logger.info("COUNTER: #{reason} #{metric} #{val}")
    :ok
  end

  @doc """
  Default hook on `Metrex.Meter` exit
  """
  def meter_exit(reason, metric, val) do
    Logger.info("METER: #{reason} #{metric} #{inspect(val)}")
    :ok
  end
end
