defmodule Support.RedactEx.CenterTestRedactor do
  @moduledoc false

  use RedactEx.Redactor,
    redactors: [
      {:center_ten, length: 10, algorithm: :center},
      {:center_unknown, length: :*, algorithm: :center}
    ]
end
