defmodule Support.RedactEx.BaseTestRedacter do
  @moduledoc false

  use RedactEx.Redacter,
    redacters: [
      {[:base, "string_base"], lengths: [1, 5, 8]},
      {:fallback, length: :*, fallback_value: "(fallback redact)"}
    ]
end
