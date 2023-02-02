defmodule Support.RedactEx.Algorithms.CustomPreciseAlgorithm do
  @moduledoc false

  @behaviour RedactEx.Algorithms.Algorithm

  @impl RedactEx.Algorithms.Algorithm
  def generate_ast(%{name: name, length: len}) do
    quote do
      def unquote(name)(<<head::binary-size(unquote(len))>> = value) do
        "(custom precise redact len #{unquote(len)}) #{value}"
      end
    end
  end

  @impl RedactEx.Algorithms.Algorithm
  def parse_extra_configuration!(_), do: %{}
end
