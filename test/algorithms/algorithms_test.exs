defmodule RedactEx.Algorithms.AlgorithmsTest do
  use ExUnit.Case, aync: true

  alias RedactEx.Algorithms
  alias Support.RedactEx.Algorithms.CustomAlgorithm

  test "validate algorithms" do
    assert CustomAlgorithm = Algorithms.valid_algorithm?(CustomAlgorithm)

    # Non existent module
    assert_raise(RuntimeError, fn ->
      CustomAlgorithm = Algorithms.valid_algorithm?(IDoNotExistMan)
    end)

    # Module do not conform to specs
    assert_raise(RuntimeError, fn ->
      CustomAlgorithm = Algorithms.valid_algorithm?(List)
    end)
  end
end
