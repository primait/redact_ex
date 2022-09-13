defmodule Support.Compliance.CenterTestMasker do
  @moduledoc false

  use RedactEx.Redacter,
    redacters: [
      {10, aliases: [:center_ten], algorithm: :center},
      {:*, aliases: [:center_unknown], algorithm: :center}
    ]
end
