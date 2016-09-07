defmodule ImgOut.ImageSupervisor do
  @moduledoc """
  A pooled supervisor for ImgOut.ImageWorker
  """

  use Supervisor

  @pool_size Application.get_env(:imgout, :gm_pool_size)
  @pool_max_overflow Application.get_env(:imgout, :gm_pool_max_overflow)

  @doc false
  def start_link,
    do: Supervisor.start_link(__MODULE__, [], name: __MODULE__)

  @doc false
  def init([]) do
    worker_pool_options = [
      name: {:local, :gm_worker_pool},
      worker_module: ImgOut.ImageWorker,
      size: @pool_size,
      max_overflow: @pool_max_overflow
    ]

    children = [
      :poolboy.child_spec(:gm_worker_pool, worker_pool_options, [])
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]

    supervise(children, opts)
  end
end
