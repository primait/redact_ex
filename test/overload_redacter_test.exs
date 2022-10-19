defmodule RedactEx.OverloadRedactTest do
  use ExUnit.Case, aync: true

  alias Support.RedactEx.OverloadTestRedactor

  test "1-length, 5-length and 8-length redactors are exported" do
    assert OverloadTestRedactor.overload("1") == "*"
    assert OverloadTestRedactor.overload("12") == "**"
    assert OverloadTestRedactor.overload("123") == "***"
    assert OverloadTestRedactor.overload("1234") == "1***"
  end

  test "fallback reload work as expected" do
    assert OverloadTestRedactor.overload("1234567890") == "12********"
  end
end
