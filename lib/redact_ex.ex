defmodule RedactEx do
  @moduledoc """
  RedactEx provides protocols and derivatoin utilities to work with
  sensitive data that should be redacted in logs and external facing tools

  * `[RedactEx.Redacter](./RedactEx.Redacter.html)` module gives you automagical generation of redacting
     functions under a desired module namespace
  * `[RedactEx.Redactable](./RedactEx.Redactable.html)` is the protocol for which implementation and
     derivation should be created to ensure the best possible practices
     in your codebase
  """
end
