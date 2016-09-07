defmodule ImgOut.StorageWorker do
  @moduledoc """
  Worker for remote storage
  """

  use GenServer

  ## Public api

  @doc """
  Read data from remote endpoints.
  """
  def read({:ok, img}),
    do: {:ok, img}
  def read({:error, status, reason}),
    do: {:error, status, reason}
  def read(id),
    do: GenServer.call(__MODULE__, {:read, id})

  ## Callbacks

  @doc false
  def start_link,
    do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  @doc false
  def init(_opts),
    do: {:ok, []}

  @doc false
  def handle_call({:read, id}, _from, state),
    do: {:reply, ImgOut.StorageService.read(id), state}
end
