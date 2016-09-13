use Mix.Config

config :memcache_client,
  host: "127.0.0.1",
  port: 11211,
  auth_method: :none,
  username: "",
  password: "",
  pool_size: 50,
  pool_max_overflow: 0

config :imgout,
  acceptors: 50,
  gm_pool_size: 25,
  gm_pool_max_overflow: 0,
  gm_timeout: 5000,
  cache_pool_size: 50,
  cache_pool_max_overflow: 0,
  remote_storage_url: "http://localhost:4000/images",
  remote_storage_pool_size: 50,
  remote_storage_pool_max_overflow: 0
