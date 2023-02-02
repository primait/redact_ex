defmodule RedactEx.OverloadRedactTest do
  use ExUnit.Case, aync: true

  alias Support.RedactEx.OverloadTestRedactor

  test "1-length, 2-length and 3..5-length redactors are exported" do
    assert OverloadTestRedactor.overload("1") == "*"
    assert OverloadTestRedactor.overload("12") == "**"
    assert OverloadTestRedactor.overload("123") == "***"
    assert OverloadTestRedactor.overload("1234") == "1***"
    assert OverloadTestRedactor.overload("1235") == "1***"
  end

  test "7..9-length use custom redactor" do
    assert OverloadTestRedactor.overload("1234567") == "(custom precise redact len 7) 1234567"
    assert OverloadTestRedactor.overload("12345678") == "(custom precise redact len 8) 12345678"
    assert OverloadTestRedactor.overload("123456789") == "(custom precise redact len 9) 123456789"
  end

  test "fallback reload work as expected" do
    assert OverloadTestRedactor.overload("1234567890") == "12********"
  end
end
