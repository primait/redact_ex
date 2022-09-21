defprotocol RedactEx.Redactable do
  @moduledoc """
  Protocol for defining a redact-able item, e.g. an item whose internal elements could be masked
  It shall return a redact-ed item of the same type as the input item

  You can derive Redactable protocol for a struct by using

  ```
  @derive RedactEx.Redactable(
    using: my_module,
    only: [
      myfield1: :redact_function_one,
      myfield2: :redact_function_two
  ])
  defstruct [:myfield1, :myfield2]
  ```
  """

  @fallback_to_any Application.compile_env(:redact_ex, :fallback_to_any, true)

  @type container :: struct() | map()
  @type binary_container :: String.t() | binary()
  @type any_container :: any()
  @type t :: container() | binary_container() | any_container()

  @doc """
  Redacts `value` hiding sensitive information
  """
  @spec redact(value :: t()) :: t()
  def redact(value)
end

defimpl RedactEx.Redactable, for: Any do
  # inspired by Jason.Encoder protocol implementation https://github.com/michalmuskala/jason/blob/e860f7c6a99be17b32ec7f8862d779a7bdddbe2b/lib/encoder.ex

  defmacro __deriving__(module, struct, opts) do
    fields = fields_to_redact(struct, opts)

    quote do
      defimpl RedactEx.Redactable, for: unquote(module) do
        def redact(%_{} = value) do
          Enum.reduce(
            unquote(fields),
            value,
            fn {key, {module, function}}, acc ->
              Map.update!(acc, key, fn val -> :erlang.apply(module, function, [val]) end)
            end
          )
        end
      end
    end
  end

  def redact(value) do
    raise Protocol.UndefinedError,
      protocol: @protocol,
      value: value,
      description: "RedactEx.Redactable protocol must always be explicitly implemented"
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
    Enum.each(fields_to_redact, fn {_, {redacter_module, redacter_function}} ->
      Code.ensure_loaded!(redacter_module)
      # true = Module.defines?(redacter_module, {redacter_function, 1})
      true = Kernel.function_exported?(redacter_module, redacter_function, 1)
    end)
  end

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
