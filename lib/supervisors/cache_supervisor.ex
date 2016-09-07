defmodule ImgOut.CacheSupervisor do
  @moduledoc """
  A supervisor for ImgOut.CacheWorker
  """

  use Supervisor

  @doc false
  def start_link,
    do: Supervisor.start_link(__MODULE__, [], name: __MODULE__)

  @doc false
  def init([]) do
    children = [
      worker(ImgOut.CacheWorker, [])
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]

    supervise(children, opts)
  end
end
