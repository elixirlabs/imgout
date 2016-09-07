defmodule ImgOut.StorageSupervisor do
  @moduledoc """
  A supervisor for ImgOut.StorageWorker
  """

  use Supervisor

  @doc false
  def start_link,
    do: Supervisor.start_link(__MODULE__, [], name: __MODULE__)

  @doc false
  def init([]) do
    children = [
      worker(ImgOut.StorageWorker, []),
      supervisor(ImgOut.CacheSupervisor, [])
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]

    supervise(children, opts)
  end
end
