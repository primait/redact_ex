defmodule Support.RedactEx.OverloadTestRedactor do
  @moduledoc false

  alias Support.RedactEx.Algorithms.CustomPreciseAlgorithm

  use RedactEx.Redactor,
    redactors: [
      {:overload, length: 1},
      {:overload, length: 2},
      {:overload, lengths: 3..5},
      {:overload, lengths: 7..9, algorithm: CustomPreciseAlgorithm}
    ]
end
