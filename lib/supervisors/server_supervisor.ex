defmodule ImgOut.ServerSupervisor do
  @moduledoc """
  A server supervisor using Cowboy web server
  """

  use Supervisor

  @doc false
  def init(options),
    do: options

  @doc false
  def start_link do
    {:ok, _} = Plug.Adapters.Cowboy.http ImgOut.ServerWorker, [],
      port: String.to_integer(System.get_env("PORT") || "4000"),
      acceptors: Application.get_env(:imgout, :acceptors),
      compress: true
  end
end
