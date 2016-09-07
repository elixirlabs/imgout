# ImgOut [WIP]

On the fly thumbnail generator microservice using Elixir/OTP and exmagick.

# Usage

Install graphsmagick, memcached and fetch the repo:

```shell
brew install graphmagick
brew install memcached
git clone git@github.com:mustafaturan/imgout.git
cd imgout
```

Configure memcache and remote storage url on `config/dev.exs`:

```elixir
config :memcache_client,
  host: "127.0.0.1",
  port: 11211,
  auth_method: :none,
  username: "",
  password: "",
  pool_size: 10,
  pool_max_overflow: 10

config :imgout,
  remote_storage_url: "http://localhost:4000/images",
  acceptors: 50,
  gm_pool_size: 10,
  gm_pool_max_overflow: 0,
  gm_timeout: 15000
```

Fetch dependencies and run the server:

```shell
mix deps.get
iex -S mix
```

For using local images put some images under `public/images` path and keep remote storage url as is.

Open your browser add visit the url:

```
http://localhost:4000/{{image-name}}/{{width}}x{{height}}

image-name: name of the image under your `public/images` folder or remote file name
width: integer
height: integer
```

# Deploy to Heroku

You can use default config while deploying heroku.

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

# Todo

[ ] Add stats

# License

MIT
