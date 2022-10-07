defprotocol RedactEx.Redactable do
  @moduledoc """
  # Redactable

  Protocol for defining a redact-able item, e.g. an item whose internal elements could be masked
  It shall return a redact-ed item of the same type as the input item

  You can derive Redactable protocol for a struct by using

  ``` elixir
  defmodule MyApp.RedactStruct do
    @derive {RedactEx.Redactable,
      fields: [
        myfield1: {MyModule, :redact_function_one},
        myfield2: {MyModule, :redact_function_two},
    ]}
    defstruct [:myfield1, :myfield2]
  end
  ```

  options

  * `:fields`    possible values of `fields` are a keyword list of configurations, where configuration can be
    * `{module, function}`, e.g.

      ``` elixir
      fields: [
          myfield1: {MyModule, :redact_function_one},
          myfield2: {MyModule, :redact_function_two},
      ]
      ```

      In this case redacting will be applied to `myfield1` and `myfield2`  using module.function as configured
    * `:redact`, e.g.

      ``` elixir
      fields: [
        field: :redact
      ]
      ```

      In this case it is expected for value in `field` to have an Impl for `RedactEx.Redactable`, and `RedactEx.Redactable.redact/1` will be called
    * `:drop`, e.g.

      ``` elixir
      fields: [
        field: :drop
      ]
      ```

      In this case `:field` key is entirely dropped. **NOTE** that this also means
      struct information will be lost, and the value will become a map

  e.g. suppose you define a module like

  ```
  #{File.read!("./test/support/derive/redact_struct.ex")}
  ```

  then you can expect it to have derived the `RedactEx.Redactable` protocol

      ```
      iex> %MyApp.RedactStruct{myfield: "reverseme"} |> RedactEx.Redactable.redact() |> Map.get(:myfield)
      "emesrever"
      ```

  ## Best Practices

  Good practices could be to implement the Inspect protocol for sensitive data and use the derived `redact`
  capabilities of the inspected module inside its implementation.
  You can both `derive` single fields in your struct, or define whatever implementation fits best
  for your structs as `defimpl RedactEx.Redactable, for: MyStruct`

  Then you can enforce `inspect`ing structures in your logs or export functions. Unluckily this is not a simple practice
  to enforce in an automatic flavour.
  """

  @fallback_to_any true

  @type container :: struct() | map()
  @type binary_container :: String.t() | binary()
  @type any_container :: any()
  @type t :: container() | binary_container() | any_container()

  @dialyzer {:nowarn_function, redact: 1}

  @doc """
  Redacts `value` hiding sensitive information
  """
  @spec redact(value :: t()) :: any()
  def redact(value)
end

defimpl RedactEx.Redactable, for: Any do
  # inspired by Jason.Encoder protocol implementation https://github.com/michalmuskala/jason/blob/e860f7c6a99be17b32ec7f8862d779a7bdddbe2b/lib/encoder.ex

  defmacro __deriving__(module, struct, opts) do
    fields = fields_to_redact(struct, opts)

    case fields do
      {redacter_module, function} -> redact_all_ast(module, redacter_module, function)
      fields when is_list(fields) -> redact_ast(module, fields)
    end
  end

  def redact(value) do
    raise Protocol.UndefinedError,
      protocol: @protocol,
      value: value,
      description: "RedactEx.Redactable protocol must always be explicitly implemented"
  end

  defp redact_all_ast(module, redacter_module, function) do
    quote do
      defimpl RedactEx.Redactable, for: unquote(module) do
        def redact(%_{} = value) do
          :erlang.apply(unquote(redacter_module), unquote(function), [value])
        end
      end
    end
  end

  defp redact_ast(module, fields) do
    quote do
      defimpl RedactEx.Redactable, for: unquote(module) do
        def redact(%_{} = value) do
          Enum.reduce(
            unquote(fields),
            value,
            fn
              {key, :drop}, acc ->
                acc |> Map.from_struct() |> Map.drop([key])

              {key, :redact}, acc ->
                Map.update!(acc, key, &RedactEx.Redactable.redact/1)

              {key, {module, function}}, acc ->
                Map.update!(acc, key, fn val -> :erlang.apply(module, function, [val]) end)
            end
          )
        end
      end
    end
  end

  defp fields_to_redact(struct, opts) do
    struct_fields = Map.keys(struct)
    fields_to_redact = Keyword.fetch!(opts, :fields)

    :ok = check_fields_to_redact!(struct_fields, fields_to_redact)
    :ok = check_fields_to_redact_configuration!(fields_to_redact)

    fields_to_redact
  end

  defp keys_from_opts(opts) do
    Enum.map(opts, fn {key, _config} -> key end)
  end

  defp check_fields_to_redact_configuration!(fields_to_redact) do
    Enum.each(fields_to_redact, fn
      {_, action} when action in [:redact, :drop] ->
        true

      {_, {redacter_module, redacter_function}} ->
        Code.ensure_loaded!(redacter_module)
        # true = Module.defines?(redacter_module, {redacter_function, 1})
        true = Kernel.function_exported?(redacter_module, redacter_function, 1)
    end)
  end

  # redact all fields
  defp check_fields_to_redact!(_struct_fields, :redact), do: :ok

  defp check_fields_to_redact!(struct_fields, fields_to_redact) do
    case keys_from_opts(fields_to_redact) -- struct_fields do
      [] ->
        :ok

      error_keys ->
        raise ArgumentError,
              "`:fields` specified keys (#{inspect(error_keys)}) that are not defined in defstruct: " <>
                "#{inspect(struct_fields -- [:__struct__])}"
    end
  end
end
