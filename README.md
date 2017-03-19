ExTermit
==============

Library for serializing Erlang terms to signed encrypted binaries and reliably deserializing them back.

The original project/idea is: https://github.com/dvv/termit

This project includes updated hashing algorithms and replacing deprecated functions.
Usage
--------------

A typical use case is to provide means to keep secrets put in public domain, e.g. secure cookies.

```elixir
term = {:a, :b, :c, [:d, 'e', "foo"]}
secret = "TopSecRet"
enc = Termit.encode(term, secret)
assert {:ok, term} == Termit.decode(enc, secret)
```

Thanks
--------------

[Vladimir Dronnikov](https://github.com/dvv) for the original project idea - Termit.
