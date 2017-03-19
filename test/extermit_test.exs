defmodule ExTermitTest do
  use ExUnit.Case
  doctest ExTermit

  test "smoke test" do
    term = {:a, :b, :c, [:d, 'e', "foo"]}
    secret = "TopSecRet"
    enc = ExTermit.encode(term, secret)
    assert {:ok, term} == ExTermit.decode(enc, secret)
    #forged data
    assert ({:error, :forged} == ExTermit.decode(<<"1">>, secret))
    assert ({:error, :forged} == ExTermit.decode(<<"0", enc::binary>>, secret))
    assert ({:error, :forged} == ExTermit.decode(<<enc::binary, "1">>, secret))
  end
end
