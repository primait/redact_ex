defmodule RedactEx.CustomRedactTest do
  use ExUnit.Case, aync: true

  alias Support.RedactEx.CustomRedacter

  test "Redacter in an external module works as expected" do
    value = "some_value"
    assert CustomRedacter.redact(value) == "(custom redact) #{value}"
  end
end
