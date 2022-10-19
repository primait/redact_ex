defmodule RedactEx.Configuration.Context do
  @moduledoc """
  Context for generating a redacting function
  """

  alias __MODULE__

  defstruct length: :*,
            redactor: nil,
            keep: nil,
            plaintext_length: nil,
            redacted_size: nil,
            redacted_length: nil,
            name: nil,
            redacted_part: nil,
            string_length: nil,
            algorithm: nil,
            needs_fallback_function: nil,
            fallback_value: nil,
            extra: nil,
            except: []

  @type t :: %Context{}

  @doc """
  For fixed-length redacted strings, returns the length of the plaintext
  to be kept of the original information
  """
  @spec get_plaintext_length_redacted_length(
          string_length :: :* | integer(),
          keep :: integer(),
          redacted_size :: integer() | :auto
        ) :: {nil, nil} | {integer(), integer()}
  def get_plaintext_length_redacted_length(:*, _keep, _redacted_size), do: {nil, nil}

  def get_plaintext_length_redacted_length(string_length, keep, redacted_size) do
    plaintext_length = floor(string_length * keep / 100)
    redacted_length = get_redacted_length(redacted_size, string_length, plaintext_length)

    {plaintext_length, redacted_length}
  end

  @doc """
  Gets the actual redacted part of the string given configuration
  """
  @spec get_redactor_string(size :: nil | integer(), redactor :: char() | any()) ::
          nil | String.t()
  def get_redactor_string(nil, _redactor), do: nil

  def get_redactor_string(size, redactor) do
    1..size |> Enum.map(fn _ -> redactor end) |> List.to_string()
  end

  # Get the length of the redacted part of data
  defp get_redacted_length(:auto, string_length, plaintext_length),
    do: max(0, string_length - plaintext_length)

  defp get_redacted_length(value, _string_length, _plaintext_length), do: value
end
