use Mix.Config

config :memcache_client,
  host: System.get_env("MEMCACHE_SERVER"),
  port: (System.get_env("MEMCACHE_PORT") || "11211") |> String.to_integer,
  auth_method: :none,
  username: System.get_env("MEMCACHE_USERNAME"),
  password: System.get_env("MEMCACHE_PASSWORD"),
  pool_size: (System.get_env("MEMCACHE_POOL_SIZE") || "10") |> String.to_integer,
  pool_max_overflow: (System.get_env("MEMCACHE_POOL_MAX_OVERFLOW") || "20") |> String.to_integer

config :imgout,
  acceptors: System.get_env("SERVER_ACCEPTORS") |> String.to_integer,
  gm_pool_size: System.get_env("GM_POOL_SIZE") |> String.to_integer,
  gm_pool_max_overflow: System.get_env("GM_POOL_MAX_OVERFLOW") |> String.to_integer,
  gm_timeout: (System.get_env("GM_TIMEOUT") || "15000") |> String.to_integer,
  cache_pool_size: (System.get_env("CACHE_POOL_SIZE") || "10") |> String.to_integer,
  cache_pool_max_overflow: (System.get_env("CACHE_POOL_MAX_OVERFLOW") || "0") |> String.to_integer,
  remote_storage_url: System.get_env("REMOTE_STORAGE_URL"),
  remote_storage_pool_size: (System.get_env("REMOTE_STORAGE_POOL_SIZE") || "10") |> String.to_integer,
  remote_storage_pool_max_overflow: (System.get_env("REMOTE_STORAGE_POOL_MAX_OVERFLOW") || "0") |> String.to_integer,
