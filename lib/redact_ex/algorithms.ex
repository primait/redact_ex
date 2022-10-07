defmodule RedactEx.Algorithms do
  @moduledoc """
  Dispatcher of supported algorithms
  """

  @algorithm_simple :simple
  @algorithm_center :center
  @algorithms [@algorithm_simple, @algorithm_center]

  alias RedactEx.Algorithms.Algorithm

  # Exports for common usage
  @spec algorithm_simple :: unquote(@algorithm_simple)
  def algorithm_simple, do: @algorithm_simple

  @spec base_algorithms :: list(atom())
  def base_algorithms, do: @algorithms

  @doc """
  Validate an algorithm at configuration level
  """
  @spec valid_algorithm?(algorithm :: atom() | module()) :: :ok | no_return()
  def valid_algorithm?(algorithm) when algorithm in @algorithms, do: map_base_algorithm(algorithm)

  def valid_algorithm?(algorithm_module) when is_atom(algorithm_module) do
    with {:ensure, {:module, module}} <- {:ensure, Code.ensure_loaded(algorithm_module)},
         {:implements, true} <-
           {:implements, Algorithm.implemented_by?(module)} do
      module
    else
      # This function is not really needed, but managing the error branches here makes dialyzer unconfortable
      error -> manage_error(algorithm_module, error)
    end
  end

  @doc """
  Get the AST of a redacting function from given module and configuration
  """
  @spec generate_ast(module :: Algorithm.t(), configuration :: any()) :: Macro.t()
  def generate_ast(module, configuration), do: module.generate_ast(configuration)

  defp map_base_algorithm(@algorithm_simple), do: RedactEx.Algorithms.Simple
  defp map_base_algorithm(@algorithm_center), do: RedactEx.Algorithms.Center

  defp manage_error(algorithm_module, {:ensure, error}),
    do: raise("Module [#{inspect(algorithm_module)}] could not be loaded [#{inspect(error)}]")

  defp manage_error(algorithm_module, {:implements, _}),
    do:
      raise(
        raise "Module [#{inspect(algorithm_module)}] does not implements the #{__MODULE__} behaviour"
      )
end
