defmodule ImgOut.CacheSupervisor do
  @moduledoc """
  A supervisor for ImgOut.CacheWorker
  """

  use Supervisor

  @pool_size Application.get_env(:imgout, :cache_pool_size)
  @pool_max_overflow Application.get_env(:imgout, :cache_pool_max_overflow)

  @doc false
  def start_link,
    do: Supervisor.start_link(__MODULE__, [], name: __MODULE__)

  @doc false
  def init([]) do
    worker_pool_options = [
      name: {:local, :cache_worker_pool},
      worker_module: ImgOut.CacheWorker,
      size: @pool_size,
      max_overflow: @pool_max_overflow
    ]

    children = [
      :poolboy.child_spec(:cache_worker_pool, worker_pool_options, [])
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]

    supervise(children, opts)
  end
end
