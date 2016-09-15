defmodule ImgOut.StorageWorker do
  @moduledoc """
  Worker for remote storage
  """

  use GenServer

  @behaviour ImgOut.StorageInterface

  ## Public api

  @doc """
  Read data from remote endpoints.
  """
  def read({:ok, img}),
    do: {:ok, img}
  def read({:error, status, reason}),
    do: {:error, status, reason}
  def read(id) do
    :poolboy.transaction(:storage_worker_pool, fn(worker) ->
      GenServer.call(worker, {:read, id})
    end)
  end

  ## Callbacks

  @doc false
  def start_link(_opts),
    do: GenServer.start_link(__MODULE__, [])

  @doc false
  def init(_opts),
    do: {:ok, []}

  @doc false
  def handle_call({:read, id}, _from, state),
    do: {:reply, ImgOut.StorageService.read(id), state}
end
