defmodule RedactEx.OverloadRedactTest do
  use ExUnit.Case, aync: true

  alias Support.RedactEx.OverloadTestRedacter

  test "1-length, 5-length and 8-length redacters are exported" do
    assert OverloadTestRedacter.overload("1") == "*"
    assert OverloadTestRedacter.overload("12") == "**"
    assert OverloadTestRedacter.overload("123") == "***"
    assert OverloadTestRedacter.overload("1234") == "1***"
  end

  test "fallback reload work as expected" do
    assert OverloadTestRedacter.overload("1234567890") == "12********"
  end
end
