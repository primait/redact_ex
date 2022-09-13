defprotocol RedactEx.Redactable do
  @moduledoc """
  Protocol for defining a redact-able item, e.g. an item whose internal elements could be masked
  It shall return a redact-ed item of the same type as the input item
  """
  @fallback_to_any Application.get_env(:redact_ex, :fallback_to_any, true)

  @type container :: struct() | map()
  @type binary_container :: String.t() | binary()
  @type any_container :: any()
  @type t :: container() | binary_container() | any_container()

  @doc """
  Redacts `value` hiding sensitive information
  """
  @spec redact(value :: t()) :: t()
  def redact(value)
end
