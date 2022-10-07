defmodule RedactEx.DeriveTest do
  use ExUnit.Case, aync: true

  alias Support.RedactEx.Derive.DeriveMe
  alias Support.RedactEx.Derive.DropMe
  alias Support.RedactEx.Derive.ImplDeriveMeAsString
  alias Support.RedactEx.Derive.SubDeriveMe

  test "DeriveMe is redactable" do
    deriveme = %DeriveMe{
      field0: "field0value",
      field1: "field1value",
      substruct: %SubDeriveMe{
        field: "I will be redacted with"
      },
      keepme: "keep_me",
      keepme_number: 15
    }

    assert RedactEx.Redactable.redact(deriveme) == %DeriveMe{
             field0: "field0value redacted0",
             field1: "field1value redacted1",
             substruct: %SubDeriveMe{field: "I will be redacted with redacted0"},
             keepme: "keep_me",
             keepme_number: 15
           }
  end

  test "ImplDeriveMe implements redact on its own" do
    deriveme = %ImplDeriveMeAsString{
      field0: "field0",
      field1: "field1",
      field2: "field2"
    }

    assert RedactEx.Redactable.redact(deriveme) ==
             "I was an ImplDeriveMeAsString struct, I became a string"
  end

  test "DropMe drops fields but loses struct information" do
    dropme = %DropMe{
      field0: "redactme0",
      field_drop: "dropped"
    }

    redacted = RedactEx.Redactable.redact(dropme)

    assert redacted == %{
             field0: "redactme0 redacted0"
           }

    assert is_struct(redacted) == false
    assert Map.has_key?(redacted, :field_drop) == false
  end
end
