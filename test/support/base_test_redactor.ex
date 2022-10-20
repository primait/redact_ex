defmodule Support.RedactEx.BaseTestRedactor do
  @moduledoc false

  use RedactEx.Redactor,
    redactors: [
      {[:base, "string_base"], lengths: [1, 5, 8]},
      {:fallback, length: :*, fallback_value: "(fallback redact)"}
    ]
end
