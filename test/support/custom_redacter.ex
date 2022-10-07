defmodule Support.RedactEx.CustomRedacter do
  @moduledoc false

  alias Support.RedactEx.Algorithms.CustomAlgorithm

  use RedactEx.Redacter,
    redacters: [
      {:redact, length: :*, algorithm: CustomAlgorithm}
    ]
end
