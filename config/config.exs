use Mix.Config

import_config "#{Mix.env}.exs"

config :metrex,
  ttl: 900,
  counters: [],
  meters: [],
  hooks: Metrex.Hook.Default
