defmodule RedactEx.Algorithms.Center do
  @moduledoc """
  Simple redacting algorithm that will keep the initial and last parts of a string and
  substitutes the remaining part with given character

  ```
  # e.g.
  value_to_redact -> va***********ct
  ```
  """
  @behaviour RedactEx.Algorithms.Algorithm

  alias RedactEx.Configuration.Context

  @impl RedactEx.Algorithms.Algorithm
  def generate_ast(%Context{
        plaintext_length: nil,
        redacted_length: nil,
        keep: keep,
        name: name,
        redactor: redactor,
        fallback_value: fallback_value
      }) do
    quote do
      def unquote(name)(value) when is_binary(value) do
        string_length = String.length(value)
        keep_size = string_length * unquote(keep) / 100 / 2
        head_size = ceil(keep_size)
        tail_size = floor(keep_size)
        center_size = max(string_length - head_size - tail_size, 0)
        center_content = for _ <- 1..center_size, do: unquote(redactor), into: ""

        if center_size <= 0 do
          unquote(redactor)
        else
          String.slice(value, 0..(head_size - 1)) <>
            center_content <> String.slice(value, (string_length - tail_size)..string_length)
        end
      end

      def unquote(name)(_value), do: unquote(fallback_value)
    end
  end

  def generate_ast(%Context{
        plaintext_length: plaintext_length,
        redacted_length: redacted_length,
        name: name,
        redacted_part: redacted
      })
      when plaintext_length > 0 do
    head_length = ceil(plaintext_length / 2)
    tail_length = floor(plaintext_length / 2)

    redacted_length_in_bits = in_bits(redacted_length)

    quote do
      def unquote(name)(
            <<head::binary-size(unquote(head_length)),
              _redacted::unquote(redacted_length_in_bits),
              tail::binary-size(unquote(tail_length))>>
          ) do
        head <> unquote(redacted) <> tail
      end
    end
  end

  @impl RedactEx.Algorithms.Algorithm
  @spec parse_extra_configuration!(any()) :: %{}
  def parse_extra_configuration!(_), do: %{}

  # Utils

  defp in_bits(nil), do: nil
  defp in_bits(redacted_length), do: redacted_length * 8
end
