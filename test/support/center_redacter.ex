defmodule Support.RedactEx.CenterTestRedacter do
  @moduledoc false

  use RedactEx.Redacter,
    redacters: [
      {:center_ten, length: 10, algorithm: :center},
      {:center_unknown, length: :*, algorithm: :center}
    ]
end
