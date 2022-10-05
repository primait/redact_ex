defmodule RedactEx do
  @moduledoc """
  RedactEx provides protocols and derivatoin utilities to work with
  sensitive data that should be redacted in logs and external facing tools

  * [RedactEx.Redacter](./RedactEx.Redacter.html) module gives you automagical generation of redacting
     functions under a desired module namespace
  * [RedactEx.Redactable](./RedactEx.Redactable.html) is the protocol for which implementation and
     derivation should be created to ensure the best possible practices
     in your codebase

  ## Protect your data

  RedactEx usual protection consists in two or more steps:

  ## Generate your redacter functions

  You can generate functions to redact your specific data using [RedactEx.Redacter](./RedactEx.Redacter.html) module.

      iex> defmodule MyApp.Redacting do
      ...>    @moduledoc false
      ...>    use RedactEx.Redacter, redacters: [
      ...>      {"redact_three", length: 3, algorithm: :simple},
      ...>      {"redact", lengths: 1..3, algorithm: :simple}
      ...>    ]
      ...> end

   This will generate optimized functions and/or functions adopting the standards
   and algorithms defined in this library.

   ## Protect your structs

   The recommended way of protecting your structs is

   ### 1. Derive or implement RedactEx.Redactable

   You can use the `@derive` macro from the [RedactEx.Redactable](./RedactEx.Redactable.html) protocol,
   configured based on your needs and optionally using functions from a module generated with
   `RedactEx.Redacter` helpers, or manually define an implementation of choice, e.g.

      iex> defmodule MyApp.RedactStruct do
      ...>   @derive RedactEx.Redactable(
      ...>   fields: [
      ...>     myfield1: {MyModule, :redact_function_one},
      ...>     myfield2: {MyModule, :redact_function_two},
      ...>   ])
      ...>   defstruct [:myfield1, :myfield2]
      ...> end

   or

      iex> defmodule MyApp.RedactStruct do
      ...>   defstruct [:myfield1, :myfield2]
      ...> end
      ...> defimpl RedactEx.Redactable, for: MyApp.RedactStruct do
      ...>   def redact(_value), do: %MyApp.RedactStruct{myfield1: "(redacted)", myfield2: "(redacted)"}
      ...> end

  ### 2. Use `inspect` protocol at your advantage

  No strategy can eliminate the risk of leaking sensitive data with code only.

  Our suggested approach is to derive also the [inspect](https://hexdocs.pm/elixir/1.14.0/Inspect.html) protocol
  and use it for your struct whenever you log or send data to external systems.

  Another strategy could be to directly call `RedactEx.Redactable.redact/1` on structs when logging, but using
  `inspect` seems to us more natural and idiomatic.

  Another strategy could be to `redact` your data directly in a custom Logger backend, or whatever the system
  used for exporting potentially sensitive data.
  """
end
