defmodule RedactEx.Algorithms.Algorithm do
  @moduledoc """
  Behaviour to implement for an algorithm to be configured as a redacting algorithm
  when using RedactEx
  """

  @type t :: module()

  @doc """
  Returns the AST of the implementing algorithm, given whatever
  supported configuration
  """
  @callback generate_ast(configuration :: any()) :: Macro.t()

  @doc """
  Parses additional configuration at compile time for given algorithm.
  Configuration will be kept in Context's `extra` field
  Shall return any configuration (eventually) readable by `generate_ast` and `generate_fallback_ast`

  The function shall raise in case of errors
  """
  @callback parse_extra_configuration!(configuration :: any()) :: any() | no_return()

  @doc """
  Check that this behaviour is implemented in given module
  """
  @spec implemented_by?(module()) :: boolean()
  def implemented_by?(module) do
    :attributes
    |> module.module_info()
    |> Enum.member?({:behaviour, [__MODULE__]})
  end
end
