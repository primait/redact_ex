defmodule Support.RedactEx.CustomRedactor do
  @moduledoc false

  alias Support.RedactEx.Algorithms.CustomAlgorithm

  use RedactEx.Redactor,
    redactors: [
      {:redact, length: :*, algorithm: CustomAlgorithm}
    ]
end
