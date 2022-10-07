defmodule Support.RedactEx.Algorithms.CustomAlgorithm do
  @moduledoc false

  @behaviour RedactEx.Algorithms.Algorithm

  @impl RedactEx.Algorithms.Algorithm
  def generate_ast(%{name: name}) do
    quote do
      def unquote(name)(value) do
        "(custom redact) #{value}"
      end
    end
  end

  @impl RedactEx.Algorithms.Algorithm
  def parse_extra_configuration!(_), do: %{}
end
