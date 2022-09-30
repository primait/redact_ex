defmodule RedactEx.DeriveTest do
  use ExUnit.Case, aync: true

  alias Support.RedactEx.Derive.DeriveMe

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
