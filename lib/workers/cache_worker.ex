defmodule ImgOut.CacheWorker do
  @moduledoc """
  Worker for cache storage
  """

  use GenServer

  ## Public api

  @doc """
  Read data from cache.
  """
  def read(key) do
    :poolboy.transaction(:cache_worker_pool, fn(worker) ->
      GenServer.call(worker, {:read, key})
    end)
  end

  @doc """
  Write data to cache.
  """
  def write(key, val) do
    :poolboy.transaction(:cache_worker_pool, fn(worker) ->
      GenServer.cast(worker, {:write, key, val})
    end)
    {:ok, val}
  end

  ## Callbacks

  @doc false
  def start_link(_opts),
    do: GenServer.start_link(__MODULE__, [])

  @doc false
  def init(_opts),
    do: {:ok, []}

  @doc false
  def handle_call({:read, key}, _from, state),
    do: {:reply, ImgOut.CacheService.read(key), state}

  @doc false
  def handle_cast({:write, key, val}, state) do
    ImgOut.CacheService.write(key, val)
    {:noreply, state}
  end
end
