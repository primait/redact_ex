defmodule RedactEx.Algorithms.Simple do
  @moduledoc """
  Simple redacting algorithm that will keep the initial part of a string and
  substitutes the remaining part with given character
  """
  @behaviour RedactEx.Algorithms.Algorithm

  RedactEx.Algorithms.Algorithm

  @impl RedactEx.Algorithms.Algorithm
  def generate_ast(%{
        plaintext_length: nil,
        redacted_length: nil,
        name: name
      }) do
    raise "Could not create `#{name}`. `#{__MODULE__}` algorithm for unknown length strings has not been implemented yet"
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
  @spec generate_fallback_ast(any()) :: String.t()
  def generate_fallback_ast(_), do: "*"

  @impl RedactEx.Algorithms.Algorithm
  @spec parse_extra_configuration!(any()) :: %{}
  def parse_extra_configuration!(_), do: %{}

  # Utils

  defp in_bits(nil), do: nil
  defp in_bits(redacted_length), do: redacted_length * 8
end
