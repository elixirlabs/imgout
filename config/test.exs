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
  remote_storage_url: "http://localhost:4000/images"
