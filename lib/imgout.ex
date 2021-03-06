defmodule ImgOut do
  @moduledoc """
  ImgOut thumbnail microservice appliction.
  """

  use Application

  @doc false
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(ImgOut.MicroserviceSupervisor, []),
      supervisor(ImgOut.ImageSupervisor, []),
      supervisor(ImgOut.StorageSupervisor, [])
    ]

    opts = [strategy: :one_for_one, name: ImgOut.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
