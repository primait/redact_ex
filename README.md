[![CI status](https://drone-1.prima.it/api/badges/primait/redact_ex/status.svg?branch=master)](https://drone-1.prima.it/primait/redact_ex) [![Test Coverage](https://github.com/primait/redact_ex/workflows/Test%20Coverage/badge.svg)](https://github.com/primait/redact_ex/actions?query=workflow%3A%22Test+Coverage%22)

# redact_ex

Utilities to redact sensitive data in Elixir projects

## Redacting

By *redacting* we consider here the practice of hiding part of a potentially sensitive information, while keeping a small part
of it to allow understanding that it may be a valid one.

For example, you may want to *redact* a telephone number in your logs, but keep the initial digits (e.g. the prefix) because that information is relevant
to  your understanding of the system, and at the same moment it does not expose any sensitive information.

## Configuration

## Usage

See [RedactEx](./lib/redact_ex.ex) for general information about this library and its intended use
See [RedactEx.Redacter](./lib/redact_ex/redacter.ex) for generating fast redacters for strings
See [RedactEx.Redactable](./lib/redact_ex/redactable.ex) protocol for deriving redactable structs

## Contributing

The recommended way to work is to use [asdf](https://github.com/asdf-vm/asdf) language runtime versions manager.

You will find a [.tool-versions.recommended](./tool-versions.recommended) file that - hopefully - is up to date with the versions used in CI.

Please be sure that your test pass with those versions before pushing to save yourself the wait for automatic checks.

``` bash
# Use project's defaults
cp .tool-versions.recommended .tool-versions
```

## TODO

- [ ] Expand explanation of fallback custom implementations of algorithms
- [ ] fix dialyzer :(

## Open Points

   * Other ways of redacting (e.g. first X letters and last Y exposed)
   * maybe-email redacter (with fallback)?
   * define a default strict implementation for `redact` in the `Any` implementation?
   * some other default magic configuration in derive, e.g. a default module+function?
