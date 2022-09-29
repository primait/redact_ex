defmodule RedactEx.EnvRedacterTest do
  use ExUnit.Case, aync: true

  alias Support.RedactEx.EnvRedacter

  test "functions are exported or not exported as expected" do
    assert function_exported?(EnvRedacter, :in_test, 1)
    refute function_exported?(EnvRedacter, :not_in_test, 1)
  end
end
