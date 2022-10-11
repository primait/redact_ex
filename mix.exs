defmodule RedactEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :redact_ex,
      version: get_version(System.get_env("DRONE_TAG")),
      source_url: "https://github.com/primait/redact_ex",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      aliases: aliases(),
      description: description(),
      deps: deps(),
      dialyzer: [
        plt_add_apps: [:mix, :ex_unit],
        list_unused_filters: true
      ],
      consolidate_protocols: Mix.env() != :test,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      # Docs
      name: "RedactEx",
      source_url: "https://github.com/primait/redact_ex",
      homepage_url: "https://github.com/primait/redact_ex",
      docs: docs(),
      package: package()
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [] ++ dev_deps()
  end

  defp dev_deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test]},
      {:dialyxir, "~> 1.1", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ci_aliases() ++ check_aliases()
  end

  defp ci_aliases do
    [
      "ci.compile": ["compile.check"],
      "ci.credo": ["credo -a --strict"],
      "ci.deps": ["deps.unlock --check-unused"],
      "ci.dialyzer": ["dialyzer"],
      "ci.format": ["format.check"],
      "ci.test": ["test"]
    ]
  end

  defp check_aliases do
    [
      "compile.check": [
        "compile --all-warnings --ignore-module-conflict --warnings-as-errors --debug-info"
      ],
      "format.check": [
        "format --check-formatted mix.exs \"lib/**/*.{ex,exs}\" \"test/**/*.{ex,exs}\" \"priv/**/*.{ex,exs}\" \"config/**/*.{ex,exs}\""
      ],
      "format.all": [
        "format mix.exs \"lib/**/*.{ex,exs}\" \"test/**/*.{ex,exs}\" \"priv/**/*.{ex,exs}\" \"config/**/*.{ex,exs}\""
      ]
    ]
  end

  defp docs,
    do: [
      # The main page in the docs
      main: "RedactEx",
      # logo: "path/to/logo.png",
      extras: ["README.md"]
    ]

  defp package,
    do: [
      name: "redact_ex",
      maintainers: ["Luca Dei Zotti"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/primait/redact_ex"}
    ]

  defp description, do: "Utilities and best practices to redact potentially sensitive data"

  defp get_version(""), do: "0.0.0-dev"
  defp get_version(nil), do: "0.0.0-dev"
  defp get_version(drone_tag), do: drone_tag
end
