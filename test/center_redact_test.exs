defmodule RedactEx.CenterRedactTest do
  use ExUnit.Case, aync: true

  alias Support.RedactEx.CenterTestRedacter

  test "center masker works as expected for fixed length strings" do
    assert CenterTestRedacter.center_ten("1234567890") == "1********0"
  end

  test "center masker works as expected for unknown length strings" do
    assert CenterTestRedacter.center_unknown("1") == "*"

    assert CenterTestRedacter.center_unknown("12345678901234567890") ==
             "123***************90"
  end
end
