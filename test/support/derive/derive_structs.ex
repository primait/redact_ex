defmodule Support.RedactEx.Derive.Redacter do
  def redact0(value), do: "#{value} redacted0"
  def redact1(value), do: "#{value} redacted1"
end

defmodule Support.RedactEx.Derive.DeriveMe do
  @derive {RedactEx.Redactable,
           fields: [
             field0: {Support.RedactEx.Derive.Redacter, :redact0},
             field1: {Support.RedactEx.Derive.Redacter, :redact1}
           ]}
  defstruct [:field0, :field1]
end
