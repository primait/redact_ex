defmodule RedactEx.Redacter do
  @default_redacting_keep 25
  @default_redacted_size :auto
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
      7

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
   `redacters`  a list of redacting rules. Each element can be:
                - a tuple in the form {redacter_function_name, configuration}
                - a tuple in the form {[redacter_function_names], configuration}
                - a single redacter_function_name
                `redacter_function_name` can be an atom or string value in all cases

  ### Common configuration

  Configuration of a redacter is a keyword list containing

    * `redacter`        string                              character used to redact the hidden part of the. Defaults to `#{@default_redacter}`
    * `redacted_size`   integer | :auto                     length of the resulting string that will be set as redacted. Defaults to `#{@default_redacted_size}`,
                                                            which will set it to `expected_string_length - keep`
    * `algorithm`       atom | module                       algorithm used to redact the string. Defaults to `#{@default_redacting_algorithm}`
                                                            if a module is given, it must implement the `RedactEx.Algorithms.Algorithm` behaviour
                                                            Supported atoms are
                                                            - `:simple` (alias for `RedactEx.Algorithms.Simple`)
                                                            - `:center` (alias for `RedactEx.Algorithms.Center`)
    * `keep`            integer                             quote of the string that will be kept. Defaults to `#{@default_redacting_keep}%`
    * `length`          integer or  `:*`                    length of the string to be considered. `:*` stands for the fallback function configuration. Is overridden by key `:lengths` if present
    * `lengths`         [integer or `:*`] | min..max        lengths of the strings to be considered. `:*` stands for the fallback function configuration. A function for each specific length will be generated
    * `except`          list(atom())                        list of environments for which this configuration will have effect
    * `fallback_value`  string                              fixed value for redacting non-string values

  ### Example

      iex> defmodule MyApp.Redacting do
      ...>    @moduledoc false
      ...>    use RedactEx.Redacter, redacters: [
      ...>      {"redact_three", length: 3, algorithm: :simple},
      ...>      {"redact", lengths: 1..3, algorithm: :simple}
      ...>    ]
      ...> end
      iex> MyApp.Redacting.redact("test")
      ...> "t***"

      This will expose the following functions:
           * `MyApp.Redacting.redact` with fast matches on input of length 1, 2, 3
           * `MyApp.Redacting.redact_three` with fast matches on input of length 3
           * both `redact/1` and `redact_three/1` will have a slower fallback function for input of different length

  ## Custom algorithms

  You can define custom algorithms to define your own implementations. Take a look at `RedactEx.Algorithms.Algorithm` behaviour.
  """

  @spec __using__(opts :: list()) :: any()
  defmacro __using__(opts) do
    redacters = Configuration.parse(opts, Mix.env(), __CALLER__)

    for {alias_name, alias_redacters} <- redacters do
      lengths = Enum.map(alias_redacters, fn %{string_length: string_length} -> string_length end)

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
              alias_redacters do
          Algorithms.generate_ast(algorithm, redacter_configuration)
        end

      List.flatten([doc_ast, function_spec_ast, fun_ast])
    end
  end
end
