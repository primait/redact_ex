defmodule Support.RedactEx.EnvRedacter do
  @moduledoc false

  use RedactEx.Redacter,
    redacters: [
      {"in_test", lengths: [1, 5, 8]},
      {"not_in_test", lengths: [1, 5, 8], except: [:test]}
    ]
end
