defmodule ExTermitTest do
  use ExUnit.Case
  doctest ExTermit

  test "smoke test" do
    term = {:a, :b, :c, [:d, 'e', "foo"]}
    secret = "TopSecRet"
    enc = Termit.encode(term, secret)
    assert {:ok, term} == Termit.decode(enc, secret)
    #forged data
    assert ({:error, :forged} == Termit.decode(<<"1">>, secret))
    assert ({:error, :forged} == Termit.decode(<<"0", enc::binary>>, secret))
    assert ({:error, :forged} == Termit.decode(<<enc::binary, "1">>, secret))
  end
end
