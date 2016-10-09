defmodule ImgOut.Mixfile do
  use Mix.Project

  def project do
    [app: :imgout,
     version: "0.2.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :cowboy, :plug, :httpoison, :memcache_client, :metrex],
     mod: {ImgOut, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:cowboy, "~> 1.0"},
     {:plug, "~> 1.2"},
     {:memcache_client, "~> 1.0"},
     {:httpoison, "~> 0.9.0"},
     {:poolboy, "~> 1.5"},
     {:exmagick, "~> 0.0.5"},
     {:metrex, "~> 0.2.0"},
     {:mock, "~> 0.1.3", only: :test}]
  end
end
