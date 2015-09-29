defmodule Note.Mixfile do
  use Mix.Project

  def project do
    [app: :note,
     version: "0.0.1",
     elixir: "~> 1.1",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [mod: {Note, []}, applications: applications(Mix.env)]
  end

  def applications(:test) do
    [:blacksmith | applications]
  end

  def applications(_), do: applications

  def applications do
    [
      :phoenix,
      :phoenix_html,
      :cowboy,
      :logger,
      :phoenix_ecto,
      :postgrex,
      :comeonin
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp deps do
    [
      {:phoenix, "~> 1.0.2"},
      {:phoenix_ecto, "~> 1.1"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.1"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:cowboy, "~> 1.0"},

      {:comeonin, "~> 1.2"},
      {:guardian, "~> 0.6"},

      {:blacksmith, "~> 0.1", only: :test}
    ]
  end
end
