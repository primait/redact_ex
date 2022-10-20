defmodule Support.RedactEx.EnvRedactor do
  @moduledoc false

  use RedactEx.Redactor,
    redactors: [
      {"in_test", lengths: [1, 5, 8]},
      {"not_in_test", lengths: [1, 5, 8], except: [:test]}
    ]
end
