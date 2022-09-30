defmodule Support.RedactEx.Derive.Redacter do
  def redact0(value) when is_binary(value), do: "#{value} redacted0"

  def redact1(value), do: "#{value} redacted1"
end

defmodule Support.RedactEx.Derive.SubDeriveMe do
  @derive {RedactEx.Redactable,
           fields: [
             field: {Support.RedactEx.Derive.Redacter, :redact0}
           ]}
  defstruct [:field]
end

defmodule Support.RedactEx.Derive.ImplDeriveMeAsString do
  defstruct [:field0, :field1, :field2]
end

defimpl RedactEx.Redactable, for: Support.RedactEx.Derive.ImplDeriveMeAsString do
  def redact(%Support.RedactEx.Derive.ImplDeriveMeAsString{} = _value) do
    "I was an ImplDeriveMeAsString struct, I became a string"
  end
end

defmodule Support.RedactEx.Derive.DeriveMe do
  @derive {RedactEx.Redactable,
           fields: [
             field0: {Support.RedactEx.Derive.Redacter, :redact0},
             field1: {Support.RedactEx.Derive.Redacter, :redact1},
             substruct: :redact
           ]}
  defstruct [:field0, :field1, :substruct, :keepme, :keepme_number]
end

defmodule Support.RedactEx.Derive.DropMe do
  @derive {RedactEx.Redactable,
           fields: [
             field0: {Support.RedactEx.Derive.Redacter, :redact0},
             field_drop: :drop
           ]}
  defstruct [:field0, :field_drop]
end
