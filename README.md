[![CI status](https://drone-1.prima.it/api/badges/primait/redact_ex/status.svg?branch=master)](https://drone-1.prima.it/primait/redact_ex) [![Test Coverage](https://github.com/primait/redact_ex/workflows/Test%20Coverage/badge.svg)](https://github.com/primait/redact_ex/actions?query=workflow%3A%22Test+Coverage%22)

# redact_ex

Utilities to redact sensitive data in Elixir projects

## Redacting

By *redacting* we consider here the practice of hiding part of a potentially sensitive information, while keeping a small part
of it to allow understanding that it may be a valid one.

For example, you may want to *redact* a telephone number in your logs, but keep the initial digits (e.g. the prefix) because that information is relevant
to  your understanding of the system, and at the same moment it does not expose any sensitive information.

## Configuration

### fallback_to_any

You may want to opt-out from fallbacking to a default implementation by configuring

``` elixir
# config.exs

config :redact_ex, :fallback_to_any, false
```

## Open points

   * Other ways of masking (e.g. first X letters and last Y exposed)
   * Make slightly faster the fallback slow version
   * Switch to enable/disable masking per environment?
   * Fallback masker atm is forced to :simple
   * maybe-email masker (with fallback)?
