defmodule ExTermit do
  use Bitwise
  @moduledoc """
  Serialize an Elixir term to signed encrypted binary and
  deserialize it back ensuring it's not been forged.

   Some code extracted from
     https://github.com/mochi/mochiweb/blob/master/src/mochiweb_session.erl
     https://github.com/dvv/termit/blob/master/src/termit.erl

  """

  @doc """
  Serialize Term, encrypt and sign the result with Secret.
  Return binary
  """
  @spec encode(term :: any, secret :: binary()) :: binary()
  def encode(term, secret) do
    key = key(secret)
    enc = encrypt(:erlang.term_to_binary(term, [:compressed, {:minor_version, 1}]),
                  key, :crypto.strong_rand_bytes(16))
    << (sign(enc, key)) :: binary, enc :: binary >>
  end

  @spec key(binary()) :: binary()
  defp key(secret) do
    :crypto.hash(:sha256, secret)
  end

  @spec sign(binary(), binary()) :: binary()
  defp sign(data, key) do
    :crypto.hmac(:sha256, key, data)
  end

  @spec encrypt(binary(), binary(), binary()) :: binary()
  defp encrypt(data, key, iv) do
    crypt = :crypto.block_encrypt(:aes_cfb128, key, iv, data)
    << iv :: binary, crypt :: binary>>
  end

  @doc """
  Given a result of encode/2, i.e. a signed encrypted binary,
   check the signature, uncrypt and deserialize into original term.
  """
  @spec decode(binary(), binary()) :: {:ok, any()} | {:error, :forged} | {:error, :badarg}
  def decode(<< sig :: binary-size(32), enc :: binary >>, secret) do
    key = key(secret)
    # NB constant time signature verification
    case equal(sig, sign(enc, key)) do
      true ->
        # deserialize
        try do
          term = :erlang.binary_to_term(uncrypt(enc, key), [:safe])
          {:ok, term}
        rescue _ ->
          {:error, :badarg}
        end
      false ->
        {:error, :forged}
    end
  end

  # N.B. unmatched binaries are forged
  def decode(bin, _) when is_binary(bin) do
    {:error, :forged}
  end

  @spec uncrypt(binary(), binary()) :: binary()
  def uncrypt(<< iv :: binary-size(16), data :: binary >>, key) do
    :crypto.block_decrypt(:aes_cfb128, key, iv, data)
  end


  @doc """
  'Constant' time =:= operator for binaries, to mitigate timing attacks
  """
  @spec equal(binary(), binary()) :: true | false
  def equal(a, b), do: equal(a, b, 0)
  def equal(<< a::integer-native, as::binary >>, << b :: integer-native, bs :: binary >>, acc), do: equal(as, bs, bor(acc, (bxor(a, b))))
  def equal("", "", 0), do: true
  def equal(_as, _bs, _acc), do: false
  
end
