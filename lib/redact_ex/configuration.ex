defmodule RedactEx.Configuration do
  @moduledoc """
  Configuration helpers for handling RedactEx configuration
  """

  @default_redacting_keep 25
  @default_redacted_size :auto
  @default_redacter "*"
  @default_redacting_algorithm RedactEx.Algorithms.algorithm_simple()
  @default_lengths [:*]
  @default_except []

  @default_configuration [
    keep: @default_redacting_keep,
    redacted_size: @default_redacted_size,
    redacter: @default_redacter,
    algorithm: @default_redacting_algorithm,
    lengths: @default_lengths,
    except: @default_except
  ]

  alias RedactEx.Algorithms
  alias RedactEx.Configuration.Context

  @doc """
  Return configurations grouped by name, so we can generate matching and catchall in a good order
  when needed
  """
  @spec parse(configuration :: list(), current_env :: atom()) :: %{atom() => list(map())}
  def parse(configuration, current_env) when is_list(configuration),
    do:
      configuration
      |> Keyword.fetch!(:redacters)
      |> Enum.flat_map(&parse_redacter/1)
      |> reject_by_env(current_env)
      |> Enum.group_by(fn %{name: name} = _config -> name end)
      |> Enum.map(&add_fallback_redacter!(&1))
      |> Enum.into(%{})

  defp reject_by_env(redacters, current_env),
    do:
      Enum.reject(redacters, fn %Context{except: refute_envs} ->
        current_env in refute_envs
      end)

  defp parse_redacter({aliases, config}) when is_list(aliases),
    do: Enum.flat_map(aliases, &map_lengths_and_parse(&1, config))

  # Single name: all defaults apply
  # Name will be normalized later
  defp parse_redacter(name) when is_atom(name) or is_binary(name),
    do: map_lengths_and_parse(name, @default_configuration)

  defp parse_redacter({name, config}), do: map_lengths_and_parse(name, config)

  defp map_lengths_and_parse(name, config) do
    config
    |> get_lengths_from_config(name)
    |> Enum.map(&do_parse_redacter(&1, name, config))
  end

  defp do_parse_redacter(string_length, given_name, given_config)
       when is_integer(string_length) or string_length == :* do
    config = Keyword.merge(@default_configuration, given_config)

    except = Keyword.fetch!(config, :except)
    keep = Keyword.fetch!(config, :keep)
    redacted_size = Keyword.fetch!(config, :redacted_size)
    needs_fallback_function = needs_fallback_function?(string_length)

    algorithm = config |> Keyword.fetch!(:algorithm) |> validate_algorithm()

    name = alias_name(given_name)

    redacter = Keyword.fetch!(config, :redacter)

    {plaintext_length, redacted_length} =
      Context.get_plaintext_length_redacted_length(string_length, keep, redacted_size)

    redacted = Context.get_redacter_string(redacted_length, redacter)

    extra = algorithm.parse_extra_configuration!(config)

    %Context{
      redacted_size: redacted_size,
      length: string_length,
      redacter: redacter,
      keep: keep,
      plaintext_length: plaintext_length,
      redacted_length: redacted_length,
      name: name,
      redacted_part: redacted,
      string_length: string_length,
      algorithm: algorithm,
      needs_fallback_function: needs_fallback_function,
      extra: extra,
      except: except
    }
  end

  # Normalize function names to atom
  defp alias_name(name) when is_binary(name), do: String.to_atom("#{name}")
  defp alias_name(name) when is_atom(name), do: alias_name(to_string(name))

  # Catchall fallback functions are created for non-default redact functions
  # used only when generating functions
  defp needs_fallback_function?(:*), do: false
  defp needs_fallback_function?(_), do: true

  # Algorithm validation dispatcher
  defp validate_algorithm(algorithm),
    do: Algorithms.valid_algorithm?(algorithm)

  defp get_length_from_config(config, name) do
    case Keyword.get(config, :length, :undefined) do
      :undefined -> [:*]
      num when is_integer(num) or num == :* -> [num]
      other -> raise "invalid `:length` value [#{inspect(other)}] configured for [#{name}]"
    end
  end

  defp get_lengths_from_config(config, name) do
    case Keyword.get(config, :lengths, :undefined) do
      :undefined ->
        get_length_from_config(config, name)

      [] ->
        raise "`:lengths` cannot be empty. Please configure `:lengths` or `:length` keyword in configuration for [#{name}]"

      lengths when is_list(lengths) ->
        lengths

      # range case
      {:.., [line: _], [min, max]} ->
        Enum.map(min..max, & &1)

      other ->
        raise "invalid `:lengths` value [#{inspect(other)}] configured for [#{name}]"
    end
  end

  defp add_fallback_redacter!({key, contexts}) do
    case Enum.split_with(contexts, fn %Context{length: len} -> len != :* end) do
      {non_fallback_contexts, []} ->
        {key,
         Enum.concat(non_fallback_contexts, [do_parse_redacter(:*, key, @default_configuration)])}

      {non_fallback_contexts, [fallback_context]} ->
        {key, Enum.concat(non_fallback_contexts, [fallback_context])}

      {_, [_h | _t]} ->
        raise "More than one fallback configurations found for [#{key}]"
    end
  end
end
