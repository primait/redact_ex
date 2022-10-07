defmodule MyApp.RedactStruct do
  @moduledoc false

  # For usage in RedactEx.Redactable doctests
  @derive {RedactEx.Redactable,
           fields: [
             myfield: {String, :reverse}
           ]}
  defstruct [:myfield]
end
