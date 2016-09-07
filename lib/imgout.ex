defmodule ImgOut do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(ImgOut.ServerSupervisor, []),
      supervisor(ImgOut.ImageSupervisor, []),
      supervisor(ImgOut.StorageSupervisor, [])
    ]

    opts = [strategy: :one_for_one, name: ImgOut.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
