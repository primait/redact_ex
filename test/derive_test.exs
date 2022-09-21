defmodule RedactEx.DeriveTest do
  use ExUnit.Case, aync: true

  defmodule Redacter do
    def redact0(value), do: "#{value} redacted0"
    def redact1(value), do: "#{value} redacted1"
  end

  defmodule DeriveMe do
    @derive {RedactEx.Redactable,
             fields: [
               field0: {RedactEx.DeriveTest.Redacter, :redact0},
               field1: {RedactEx.DeriveTest.Redacter, :redact1}
             ]}
    defstruct [:field0, :field1]
  end

  test "DeriveMe is redactable" do
    deriveme = %DeriveMe{
      field0: "field0value",
      field1: "field1value"
    }

    assert RedactEx.Redactable.redact(deriveme) == %DeriveMe{
             field0: "field0value redacted0",
             field1: "field1value redacted1"
           }
  end
end
