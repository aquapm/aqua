defprotocol Aqua.Jason.Encoder do
  @moduledoc false

  @type t :: term
  @type opts :: Aqua.Jason.Encode.opts()

  @fallback_to_any true

  @doc """
  Encodes `value` to JSON.

  The argument `opts` is opaque - it can be passed to various functions in
  `Jason.Encode` (or to the protocol function itself) for encoding values to JSON.
  """
  @spec encode(t, opts) :: iodata
  def encode(value, opts)
end

defimpl Aqua.Jason.Encoder, for: Any do
  defmacro __deriving__(module, struct, opts) do
    fields = fields_to_encode(struct, opts)
    kv = Enum.map(fields, &{&1, generated_var(&1, __MODULE__)})
    escape = quote(do: escape)
    encode_map = quote(do: encode_map)
    encode_args = [escape, encode_map]
    kv_iodata = Aqua.Jason.Codegen.build_kv_iodata(kv, encode_args)

    quote do
      defimpl Aqua.Jason.Encoder, for: unquote(module) do
        require Aqua.Jason.Helpers

        def encode(%{unquote_splicing(kv)}, {unquote(escape), unquote(encode_map)}) do
          unquote(kv_iodata)
        end
      end
    end
  end

  # The same as Macro.var/2 except it sets generated: true
  defp generated_var(name, context) do
    {name, [generated: true], context}
  end

  def encode(%_{} = struct, _opts) do
    raise Protocol.UndefinedError,
      protocol: @protocol,
      value: struct,
      description: """
      Jason.Encoder protocol must always be explicitly implemented.

      If you own the struct, you can derive the implementation specifying \
      which fields should be encoded to JSON:

          @derive {Jason.Encoder, only: [....]}
          defstruct ...

      It is also possible to encode all fields, although this should be \
      used carefully to avoid accidentally leaking private information \
      when new fields are added:

          @derive Jason.Encoder
          defstruct ...

      Finally, if you don't own the struct you want to encode to JSON, \
      you may use Protocol.derive/3 placed outside of any module:

          Protocol.derive(Jason.Encoder, NameOfTheStruct, only: [...])
          Protocol.derive(Jason.Encoder, NameOfTheStruct)
      """
  end

  def encode(value, _opts) do
    raise Protocol.UndefinedError,
      protocol: @protocol,
      value: value,
      description: "Jason.Encoder protocol must always be explicitly implemented"
  end

  defp fields_to_encode(struct, opts) do
    cond do
      only = Keyword.get(opts, :only) ->
        only

      except = Keyword.get(opts, :except) ->
        Map.keys(struct) -- [:__struct__ | except]

      true ->
        Map.keys(struct) -- [:__struct__]
    end
  end
end

# The following implementations are formality - they are already covered
# by the main encoding mechanism in Jason.Encode, but exist mostly for
# documentation purposes and if anybody had the idea to call the protocol directly.

defimpl Aqua.Jason.Encoder, for: Atom do
  def encode(atom, opts) do
    Aqua.Jason.Encode.atom(atom, opts)
  end
end

defimpl Aqua.Jason.Encoder, for: Integer do
  def encode(integer, _opts) do
    Aqua.Jason.Encode.integer(integer)
  end
end

defimpl Aqua.Jason.Encoder, for: Float do
  def encode(float, _opts) do
    Aqua.Jason.Encode.float(float)
  end
end

defimpl Aqua.Jason.Encoder, for: List do
  def encode(list, opts) do
    Aqua.Jason.Encode.list(list, opts)
  end
end

defimpl Aqua.Jason.Encoder, for: Map do
  def encode(map, opts) do
    Aqua.Jason.Encode.map(map, opts)
  end
end

defimpl Aqua.Jason.Encoder, for: BitString do
  def encode(binary, opts) when is_binary(binary) do
    Aqua.Jason.Encode.string(binary, opts)
  end

  def encode(bitstring, _opts) do
    raise Protocol.UndefinedError,
      protocol: @protocol,
      value: bitstring,
      description: "cannot encode a bitstring to JSON"
  end
end

defimpl Aqua.Jason.Encoder, for: [Date, Time, NaiveDateTime, DateTime] do
  def encode(value, _opts) do
    [?\", @for.to_iso8601(value), ?\"]
  end
end

defimpl Aqua.Jason.Encoder, for: Decimal do
  def encode(value, _opts) do
    # silence the xref warning
    decimal = Decimal
    [?\", decimal.to_string(value), ?\"]
  end
end

defimpl Aqua.Jason.Encoder, for: Aqua.Jason.Fragment do
  def encode(%{encode: encode}, opts) do
    encode.(opts)
  end
end
