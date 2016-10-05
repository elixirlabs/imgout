defmodule ImgOut.MetricMicroservice do
  @moduledoc """
  Metrics data dump microservice
  """

  alias Metrex.Counter
  alias Metrex.Meter

  @doc """
  Dump metrics for the given service
  """
  def process(service),
    do: process(service, Process.whereis(:"counter.#{service}.active"))

  defp process(service, nil) do
    %{meters: %{succeed: %{}, failed: %{}},
      counters: %{active: 0, succeed: 0, failed: 0, total: 0}}
  end
  defp process(service, _pid) do
    %{meters: %{
        succeed: Meter.dump(service <> ".ok") |> Enum.into(%{}),
        failed: Meter.dump(service <> ".server_error") |> Enum.into(%{})
      },
      counters: %{
        active: Counter.count(service <> ".active"),
        succeed: Counter.count(service <> ".succeed"),
        failed: Counter.count(service <> ".failed"),
        total: Counter.count(service <> ".total")
      }
    }
  end

  def service_name,
    do: "metric"
end
