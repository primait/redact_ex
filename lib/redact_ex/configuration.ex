defmodule RedactEx.Configuration do
  @moduledoc """
  Configuration helpers for handling RedactEx configuration
  """

  @default_redacting_keep 25
  @default_redacting_length :auto
  @default_redacter "*"
  @default_redacting_algorithm RedactEx.Algorithms.algorithm_simple()
  @catchall_function_name :redact

  alias RedactEx.Algorithms
  alias RedactEx.Configuration.Context

  @doc """
  Return configurations ordered by name, so we can generate matching and catchall in a good order
  """
  @spec parse(list()) :: %{atom() => list(map())}
  def parse(configuration) when is_list(configuration),
    do:
      configuration
      |> Keyword.fetch!(:redacters)
      |> Enum.flat_map(&parse_redacter/1)
      |> Enum.group_by(fn %{name: name} = _config -> name end)

  # Catch-all special case
  defp parse_redacter({:*, config}),
    do: do_parse_redacter(:*, check_catchall_aliases(config))

  # Single integer case: all defaults apply
  defp parse_redacter(string_length) when is_integer(string_length),
    do: parse_redacter({string_length, []})

  #  Range case: for each string length a full set of functions will be generated
  defp parse_redacter({_min.._max = range, config}),
    do: Enum.flat_map(range, fn string_length -> do_parse_redacter(string_length, config) end)

  defp parse_redacter({string_length, config}), do: do_parse_redacter(string_length, config)

  defp do_parse_redacter(string_length, config)
       when is_integer(string_length) or string_length == :* do
    keep = Keyword.get(config, :keep, @default_redacting_keep)
    redacted_size = Keyword.get(config, :redacted_size, @default_redacting_length)
    needs_fallback_function = needs_fallback_function?(string_length)

    algorithm =
      config |> Keyword.get(:algorithm, @default_redacting_algorithm) |> validate_algorithm()

    aliases =
      config
      |> Keyword.get(:aliases, [])
      |> aliases_names()
      |> check_has_redact_function(string_length)

    redacter = Keyword.get(config, :redacter, @default_redacter)

    {plaintext_length, redacted_length} =
      Context.get_plaintext_length_redacted_length(string_length, keep, redacted_size)

    redacted = Context.get_redacter_string(redacted_length, redacter)

    extra = algorithm.parse_extra_configuration!(config)

    for name <- aliases,
        do: %Context{
          redacter: redacter,
          keep: keep,
          plaintext_length: plaintext_length,
          redacted_length: redacted_length,
          name: name,
          redacted_part: redacted,
          string_length: string_length,
          algorithm: algorithm,
          needs_fallback_function: needs_fallback_function,
          extra: extra
        }
  end

  # Check the catchall :* configuration does NOT contain the generic catchall generated
  # for normal redacters
  defp check_catchall_aliases(config) do
    if config |> Keyword.get(:aliases, []) |> Enum.member?(@catchall_function_name) do
      raise "Catch-all configuration can NOT include [#{@catchall_function_name}] as an alias, since it is the fallback function name. Please remove it and provide at least one different alias"
    end

    config
  end

  # Transform aliases to complete names
  defp aliases_names(aliases), do: Enum.map(aliases, &alias_name/1)

  defp alias_name(name) when is_binary(name), do: String.to_atom("#{name}")
  defp alias_name(name) when is_atom(name), do: alias_name(to_string(name))

  # Catchall fallback functions are created for non-default redact functions
  # used only when generating functions
  defp needs_fallback_function?(:*), do: false
  defp needs_fallback_function?(_), do: true

  # Algorithm validation dispatcher
  defp validate_algorithm(algorithm),
    do: Algorithms.valid_algorithm?(algorithm)

  # Check that redacting function aliases are configured when needed
  defp check_has_redact_function([] = _aliases, :*),
    do:
      raise(
        "Aliases cannot be empty for generic redacters (:*). Please provide at least one alias"
      )

  defp check_has_redact_function(aliases, :*) do
    if Enum.member?(aliases, "#{@catchall_function_name}") do
      raise "Generic redacters cannot have the alias `mask`. Please remove it and provide at least one different alias"
    else
      aliases
    end
  end

  defp check_has_redact_function(aliases, _string_length),
    do: Enum.concat(aliases, [@catchall_function_name])
end
