defmodule RedactEx.Algorithms.Simple do
  @moduledoc """
  Simple redacting algorithm that will keep the initial part of a string and
  substitutes the remaining part with given character
  """
  @behaviour RedactEx.Algorithms.Algorithm

  alias RedactEx.Configuration.Context

  @impl RedactEx.Algorithms.Algorithm
  def generate_ast(%Context{
        length: :*,
        keep: keep,
        name: name,
        redacter: redacter,
        redacted_size: redacted_size
      }) do
    quote do
      def unquote(name)(value) when is_binary(value) do
        string_length = String.length(value)
        plaintext_length = floor(string_length * unquote(keep) / 100)

        {plaintext_length, redacted_length} =
          Context.get_plaintext_length_redacted_length(
            string_length,
            unquote(keep),
            unquote(redacted_size)
          )

        redacted = Context.get_redacter_string(redacted_length, unquote(redacter))

        case max(0, plaintext_length - 1) do
          0 ->
            redacted

          n ->
            String.slice(value, 0..n) <> redacted
        end
      end

      def unquote(name)(_value), do: "(fully redacted as not a string)"
    end
  end

  def generate_ast(%{
        plaintext_length: plaintext_length,
        redacted_length: redacted_length,
        name: name,
        redacted_part: redacted
      })
      when plaintext_length > 0 do
    redacted_length_in_bits = in_bits(redacted_length)

    quote do
      def unquote(name)(
            <<head::binary-size(unquote(plaintext_length)),
              rest::unquote(redacted_length_in_bits)>>
          ) do
        head <> unquote(redacted)
      end
    end
  end

  def generate_ast(%{
        redacted_length: redacted_length,
        name: name,
        redacted_part: redacted
      }) do
    redacted_length_in_bits = in_bits(redacted_length)

    quote do
      def unquote(name)(<<rest::unquote(redacted_length_in_bits)>>),
        do: unquote(redacted)
    end
  end

  @impl RedactEx.Algorithms.Algorithm
  @spec parse_extra_configuration!(any()) :: %{}
  def parse_extra_configuration!(_), do: %{}

  # Utils

  defp in_bits(nil), do: nil
  defp in_bits(redacted_length), do: redacted_length * 8
end
