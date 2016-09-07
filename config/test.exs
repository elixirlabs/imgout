use Mix.Config

config :memcache_client,
  host: "127.0.0.1",
  port: 11211,
  auth_method: :none,
  username: "",
  password: "",
  pool_size: 20,
  pool_max_overflow: 20

config :imgout,
  acceptors: 50,
  gm_pool_size: 10,
  gm_pool_max_overflow: 0,
  gm_timeout: 15000,
  cache_pool_size: 10,
  cache_pool_max_overflow: 0,
  remote_storage_url: "http://localhost:4000/images",
  remote_storage_pool_size: 10,
  remote_storage_pool_max_overflow: 0
