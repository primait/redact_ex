defmodule Support.RedactEx.BaseTestRedacter do
  @moduledoc false

  use RedactEx.Redacter,
    redacters: [
      {1, aliases: [:one, "string_one"]},
      5,
      {8, aliases: [:eight]}
    ]
end
