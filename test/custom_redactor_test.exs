defmodule RedactEx.CustomRedactTest do
  use ExUnit.Case, aync: true

  alias Support.RedactEx.CustomRedactor

  test "Redactor in an external module works as expected" do
    value = "some_value"
    assert CustomRedactor.redact(value) == "(custom redact) #{value}"
  end
end
