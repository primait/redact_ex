defmodule RedactEx.BaseRedactTest do
  use ExUnit.Case, aync: true

  alias Support.RedactEx.BaseTestRedacter

  test "1-length, 5-length and 8-length redacters are exported" do
    # length 1, 25% =~ 0
    assert BaseTestRedacter.base("1") == "*"
    assert BaseTestRedacter.string_base("1") == "*"

    # length 5, 25% =~ 1
    assert BaseTestRedacter.base("12345") == "1****"
    assert BaseTestRedacter.string_base("12345") == "1****"

    # length 8, 25% =~ 2
    assert BaseTestRedacter.base("12345678") == "12******"
    assert BaseTestRedacter.string_base("12345678") == "12******"
  end

  test "fallback values work as expected" do
    # length 2, 25% =~ 0
    assert BaseTestRedacter.base("12") == "**"
    assert BaseTestRedacter.string_base("12") == "**"

    # length 10, 25% =~ 2
    assert BaseTestRedacter.base("1234567890") == "12********"
    assert BaseTestRedacter.string_base("1234567890") == "12********"

    assert BaseTestRedacter.base(nil) == "(redacted)"
    assert BaseTestRedacter.string_base(nil) == "(redacted)"

    assert BaseTestRedacter.fallback(nil) == "(fallback redact)"
  end
end
