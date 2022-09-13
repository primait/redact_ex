defmodule Support.Compliance.MatchTestMasker do
  @moduledoc false

  use RedactEx.Redacter,
    redacters: [
      {1, aliases: [:overload]},
      {2, aliases: [:overload]},
      {3, aliases: [:overload]},
      {4, aliases: [:overload]}
    ]
end
