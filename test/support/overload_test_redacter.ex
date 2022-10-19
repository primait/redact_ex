defmodule Support.RedactEx.OverloadTestRedactor do
  @moduledoc false

  use RedactEx.Redactor,
    redactors: [
      {:overload, length: 1},
      {:overload, length: 2},
      {:overload, lengths: 3..4}
    ]
end
