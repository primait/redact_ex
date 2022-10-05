# This is a workaround for the bug described in
#  * https://github.com/jeremyjh/dialyxir/issues/221
#  * https://github.com/elixir-lang/elixir/issues/7708
#  * https://elixirforum.com/t/dialyzer-listed-not-implemented-protocols-as-unknown-functions/2099
# Unluckily this has no solution yet and dialyzer will fail before the first consolidation
[
  ~r/RedactEx.Redactable.Atom.*__impl__.*/,
  ~r/RedactEx.Redactable.BitString.*__impl__.*/,
  ~r/RedactEx.Redactable.Float.*__impl__.*/,
  ~r/RedactEx.Redactable.Function.*__impl__.*/,
  ~r/RedactEx.Redactable.Integer.*__impl__.*/,
  ~r/RedactEx.Redactable.List.*__impl__.*/,
  ~r/RedactEx.Redactable.Map.*__impl__.*/,
  ~r/RedactEx.Redactable.PID.*__impl__.*/,
  ~r/RedactEx.Redactable.Port.*__impl__.*/,
  ~r/RedactEx.Redactable.Reference.*__impl__.*/,
  ~r/RedactEx.Redactable.Tuple.*__impl__.*/
]
