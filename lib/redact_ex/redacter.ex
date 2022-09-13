defmodule RedactEx.Redacter do
  @default_redacting_keep 25
  @default_redacting_length :auto
  @default_redacter "*"

  @default_redacting_algorithm RedactEx.Algorithms.algorithm_simple()

  alias RedactEx.Algorithms
  alias RedactEx.Configuration
  alias RedactEx.Configuration.Context

  @moduledoc """
  # RedactEx

  Utility that defines a set of functions to fast-redact data where possible, e.g. when you already know
  the length of the string you're gonna have as validated input
  Redacting is unidirectional and is meant to help the safety of logs and exported data

  Note that right now this function matches on binary data, so you probably want to consider it if
  UTF-stuff is heavily involved when defining lengths.
  For example, in extreme cases, considering that a UTF-8 string may have a string length of 5 (e.g. `héllo`) but a byte size
  of 6 (as by [documentation](https://hexdocs.pm/elixir/1.14.0/String.html#module-utf-8-encoded-and-encodings))

      iex> string = "héllo"
      "héllo"
      iex> String.length(string)
      5
      iex> byte_size(string)
      6

  So you may consider it when evaluating for which kind of data you're planning to use byte-based helpers

  ## Algorithms

  ### Optimized algorithms for strings with expected length(s)

  Those algorithms will match on the byte_size of the string

  | Algorithm | Description |
  | --------- | ----------- |
  | `:simple` | keeps the first `keep`% of the string and sets the rest to `redacter`, according to `redacted_size` |
  | `:center` | splits `keep`% of the string between head and tail, and sets the middle to `redacter`, according to `redacted_size` |

  ## Configuration

  Options:
   `rules`    a list of redacting rules. Each element can be:
                - a tuple in the form {expected_string_length, configuration}
                - a tuple in the form {expected_string_min_length..expected_string_max_length, configuration}
                - a tuple in the form {:*, configuration}
                - a single expected_string_length

  ### Redacter configuration for :*

  Note that in this case the generic `:redact` alias will *not* be generated, and an error will be raised if you try to use it.
  This is because for each configured length a default (slower) fallback will always be generated.

  ### Common configuration

  Configuration of a redacter is a keyword list containing

    * `aliases`         list(atom | string)     list of aliases that will be created for the redacter
    * `redacter`        string                  character used to redact the hidden part of the. Defaults to `#{@default_redacter}`
    * `redacted_size`   integer | :auto         length of the resulting string that will be set as redacted. Defaults to `#{@default_redacting_length}`,
                                                which will set it to `expected_string_length - keep`
    * `algorithm`       atom                    algorithm used to redact the string. Defaults to `#{@default_redacting_algorithm}`
    * `except_env`      list(atom)              environments for which redacters functions will NOT be generated
    * `keep`            integer                 quote of the string that will be kept. Defaults to `#{@default_redacting_keep}%`

  ## Example

      iex> defmodule MyApp.Redacting do
              @moduledoc false
              use RedactEx.Redacter, redacters: [1, 2, {3, aliases: [:redact_three]}]
           end

      This will expose the following functions:
           * `MyApp.Redacting.redact` with fast matches on input of length 1, 2, 3
           * `MyApp.Redacting.redact_three` with fast matches on input of length 3
           * both `redact/1` and `redact_three/1` will have a slower fallback function for input of different length
  """

  @spec __using__(opts :: list()) :: any()
  defmacro __using__(opts) do
    redacters = Configuration.parse(opts)

    for {alias_name, alias_redacters} <- redacters do
      lengths = Enum.map(alias_redacters, fn %{string_length: string_length} -> string_length end)
      needs_fallback_function = Enum.at(alias_redacters, 0).needs_fallback_function

      doc_ast =
        quote do
          @doc """
          Redacter `#{unquote(alias_name)}` for strings of lengths #{unquote(inspect(lengths))}
          This is a self-generated function from `#{RedactEx.Redacter}`
          """
        end

      # iex> quote do: @spec function_name(String.t()) :: String.t()
      function_spec_ast =
        quote do
          @spec unquote(alias_name)(String.t()) :: String.t()
        end

      fun_ast =
        for %Context{algorithm: algorithm} = redacter_configuration <-
              alias_redacters |> IO.inspect() do
          Algorithms.generate_ast(algorithm, redacter_configuration)
        end

      # Create fallback rule for current alias
      fallback_ast =
        if needs_fallback_function do
          quote do
            def unquote(alias_name)(value),
              do: algorithm.fallback_redact(value)
          end
        else
          quote do
          end
        end

      List.flatten([doc_ast, function_spec_ast, fun_ast, fallback_ast])
    end
  end
end
