defmodule ImgOut.MetricMicroserviceTest do
  use ExUnit.Case, async: true
  alias ImgOut.MetricMicroservice, as: MetricMicroservice

  @thumb "thumb"

  test "process with service_name" do
    assert MetricMicroservice.process(@thumb) == %{
      meters: %{failed: %{}, succeed: %{}},
      counters: %{active: 0, total: 0, failed: 0, succeed: 0}
    }
  end

  test "service_name" do
    assert MetricMicroservice.service_name == "metric"
  end
end
