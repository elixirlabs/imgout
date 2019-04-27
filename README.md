# ImgOut [Sample Project for Meetup Talk]

On the fly thumbnail generator microservice using Elixir/OTP and exmagick.

# Usage

Install graphicsmagick, memcached and fetch the repo:

```shell
brew install graphicsmagick # necessary for exmagick
brew install memcached # necessary for caching
git clone git@github.com:elixirlabs/imgout.git
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

http://localhost:4000/thumb/{{image_name}}/{{width}}x{{height}}

image_name: name of the image under your `public/images` folder or remote file name
width: integer
height: integer
```

On production, you need to change remote storage url to source of original images. ImgOut will request to fetch original image to "{{remote_storage_url}} + / + {{image_name}}"" from source.

# Deploy to Heroku

You can use default config while deploying heroku. For test purposes change REMOTE_STORAGE_URL to "http://{{your_app_name}}.herokuapp.com/images" then visit http://{{your_app_name}}.herokuapp.com/thumb/{{image_name}}/{{width}}x{{height}}

There is a sample image under public/images folder with the name '0B58FWWTQqRCMek4zUWhCU0J3QUU' so you can visit:

http://{{your_app_name}}.herokuapp.com/thumb/0B58FWWTQqRCMek4zUWhCU0J3QUU/128x128

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

## Experiments

ImgOut has 2 other experimental branches, take a look and deploy them to heroku to see which branch is the most performant and why. Each branch has its own 'Heroku Deploy' button, so do not hesitate to deploy and see with your eyes. If you have time also read my blog post, I tried to explain all of them(https://medium.com/elixirlabs/re-design-with-elixir-otp-and-pattern-matching-b452213c7947)

## Performance

ImgOut processed more than 3k thumbs in a minute on Heroku free dyno.

*Metrics:* http://bit.ly/2bYRnpp

*Live Service metrics endpoint:* /metrics/thumb

### On Heroku Free Dyno

Data collected with deprecated `metrex` package for 60 seconds visualization on 0-100 active clients using loader.io

```js
{
  "meters": {
    "succeed": {
      "1476055126": 60,
      "1476055123": 73,
      "1476055164": 63,
      "1476055133": 53,
      "1476055155": 62,
      "1476055121": 57,
      "1476055129": 62,
      "1476055157": 55,
      "1476055179": 26,
      "1476055136": 59,
      "1476055118": 31,
      "1476055159": 64,
      "1476055160": 56,
      "1476055171": 48,
      "1476055147": 68,
      "1476055175": 56,
      "1476055158": 52,
      "1476055156": 61,
      "1476055174": 65,
      "1476055148": 43,
      "1476055127": 60,
      "1476055163": 58,
      "1476055161": 56,
      "1476055177": 65,
      "1476055170": 54,
      "1476055119": 50,
      "1476055124": 68,
      "1476055125": 60,
      "1476055122": 61,
      "1476055165": 54,
      "1476055140": 59,
      "1476055149": 75,
      "1476055135": 31,
      "1476055131": 45,
      "1476055168": 40,
      "1476055167": 68,
      "1476055146": 65,
      "1476055166": 55,
      "1476055130": 50,
      "1476055151": 62,
      "1476055134": 36,
      "1476055178": 62,
      "1476055154": 70,
      "1476055172": 59,
      "1476055143": 68,
      "1476055152": 71,
      "1476055138": 63,
      "1476055169": 60,
      "1476055142": 58,
      "1476055139": 50,
      "1476055150": 58,
      "1476055128": 59,
      "1476055132": 49,
      "1476055144": 53,
      "1476055153": 62,
      "1476055145": 54,
      "1476055137": 34,
      "1476055120": 52,
      "1476055141": 68,
      "1476055162": 61,
      "1476055173": 54,
      "1476055176": 69
    },
    "failed": {

    }
  },
  "counters": {
    "total": 3520,
    "succeed": 3520,
    "failed": 0,
    "active": 0
  }
}
```

# License

MIT
