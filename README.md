# ImgOut [WIP]

On the fly thumbnail generator microservice using Elixir/OTP and exmagick.

# Usage

Install graphsmagick, memcached and fetch the repo:

```shell
brew install graphicsmagick # necessary for exmagick
brew install memcached # necessary for caching
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
```

Fetch dependencies and run the server:

```shell
mix deps.get
iex -S mix
```

For using local images put some images under `public/images` path and keep remote storage url as is.

Open your browser add visit the url:

```

http://localhost:4000/{{image_name}}/{{width}}x{{height}}

image_name: name of the image under your `public/images` folder or remote file name
width: integer
height: integer
```

On production, you need to change remote storage url to source of original images. ImgOut will request to fetch original image to "{{remote_storage_url}} + / + {{image_name}}"" from source.

# Deploy to Heroku

You can use default config while deploying heroku. For test purposes change REMOTE_STORAGE_URL to "http://{{your_app_name}}.herokuapp.com/images" then visit http://{{your_app_name}}.herokuapp.com/{{image_name}}/{{width}}x{{height}}

There is a sample image under public/images folder with the name '0B58FWWTQqRCMek4zUWhCU0J3QUU' so you can visit:

http://{{your_app_name}}.herokuapp.com/0B58FWWTQqRCMek4zUWhCU0J3QUU/128x128

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

## Performance

ImgOut processed more than 3k thumbs in a minute on Heroku free dyno.

http://bit.ly/2bYRnpp

# Todo

[ ] Add metrics

# License

MIT
