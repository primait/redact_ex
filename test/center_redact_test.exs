defmodule RedactEx.CenterRedactTest do
  use ExUnit.Case, aync: true

  alias Support.RedactEx.CenterTestRedactor

  test "center redactor works as expected for fixed length strings" do
    assert CenterTestRedactor.center_ten("1234567890") == "1********0"
  end

  test "center redactor works as expected for unknown length strings" do
    assert CenterTestRedactor.center_unknown("1") == "*"

    assert CenterTestRedactor.center_unknown("12345678901234567890") ==
             "123***************90"
  end

  test "center redactor works as expected for fallback values" do
    assert CenterTestRedactor.center_unknown(nil) == "(redacted)"
    assert CenterTestRedactor.center_ten(nil) == "(redacted)"
  end
end
