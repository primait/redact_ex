defmodule RedactEx.BaseRedactTest do
  use ExUnit.Case, aync: true

  alias Support.RedactEx.BaseTestRedactor

  test "1-length, 5-length and 8-length redactors are exported" do
    # length 1, 25% =~ 0
    assert BaseTestRedactor.base("1") == "*"
    assert BaseTestRedactor.string_base("1") == "*"

    # length 5, 25% =~ 1
    assert BaseTestRedactor.base("12345") == "1****"
    assert BaseTestRedactor.string_base("12345") == "1****"

    # length 8, 25% =~ 2
    assert BaseTestRedactor.base("12345678") == "12******"
    assert BaseTestRedactor.string_base("12345678") == "12******"
  end

  test "fallback values work as expected" do
    # length 2, 25% =~ 0
    assert BaseTestRedactor.base("12") == "**"
    assert BaseTestRedactor.string_base("12") == "**"

    # length 10, 25% =~ 2
    assert BaseTestRedactor.base("1234567890") == "12********"
    assert BaseTestRedactor.string_base("1234567890") == "12********"

    assert BaseTestRedactor.base(nil) == "(redacted)"
    assert BaseTestRedactor.string_base(nil) == "(redacted)"

    assert BaseTestRedactor.fallback(nil) == "(fallback redact)"
  end
end
