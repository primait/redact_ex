defmodule RedactEx.EnvRedactorTest do
  use ExUnit.Case, aync: true

  alias Support.RedactEx.EnvRedactor

  test "functions are exported or not exported as expected" do
    Code.ensure_compiled!(Support.RedactEx.EnvRedactor)
    assert function_exported?(EnvRedactor, :in_test, 1)
    refute function_exported?(EnvRedactor, :not_in_test, 1)
  end
end
