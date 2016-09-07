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
  remote_storage_url: "http://example.com",
  acceptors: 50,
  gm_pool_size: 10,
  gm_pool_max_overflow: 0,
  gm_timeout: 15000
