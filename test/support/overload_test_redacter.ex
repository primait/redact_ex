defmodule Support.RedactEx.OverloadTestRedacter do
  @moduledoc false

  use RedactEx.Redacter,
    redacters: [
      {:overload, length: 1},
      {:overload, length: 2},
      {:overload, lengths: 3..4}
    ]
end
