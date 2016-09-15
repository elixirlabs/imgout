defmodule ImgOut.ImageWorker do
  @moduledoc """
  Worker for thumb generation
  """

  use GenServer

  @behaviour ImgOut.ImageInterface
  @timeout Application.get_env(:imgout, :gm_timeout)

  ## Public api

  @doc """
  Generate thumbs using ImgOut.ImageService thumb
  """
  def thumb({:ok, img}, dimensions) do
    :poolboy.transaction(:gm_worker_pool, fn(worker) ->
      GenServer.call(worker, {:thumb, {:ok, img}, dimensions}, @timeout)
    end)
  end
  def thumb({:error, status, reason}, _),
    do: {:error, status, reason}

  ## Callbacks

  @doc false
  def start_link(_opts),
    do: GenServer.start_link(__MODULE__, :ok, [])

  @doc false
  def init(_opts) do
    {:ok, []}
  end

  @doc false
  def handle_call({:thumb, {:ok, img}, dimensions}, _from, state) do
    data = ImgOut.ImageService.thumb({:ok, img}, dimensions)
    {:reply, data, state}
  end
end
