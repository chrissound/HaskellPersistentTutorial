# Real real world example - updating a database record

Okay lets try a real world example, updating a database record based on some user input (like something we'd get from a HTTP request).

To keep things simple we'll just have a `[(String,String)]` input.

In order to update a record we need to use a "Query update combinators".
I'll be using (https://hackage.haskell.org/package/persistent-2.10.4/docs/Database-Persist.html#v:-61-.)
```
(=.) :: forall v typ. PersistField typ => EntityField v typ -> typ -> Update v 
```


And then with the following defined:
```
  usermapper :: String -> String -> Update Person
  usermapper "name" = (PersonName =.)
  usermapper "age" = (PersonAge =.) . Just . read
  usermapper _ = error "Invalid field"
```

We can use the above function as below, the important bits being:

```
  let input = [
          ("id", "1")
        , ("name", "Chris")
        , ("age", "100")
        ]

  let updates = fmap (\(a,b) -> usermapper a b) $ tail input
```

Nice and simple! So our `Main.hs` ends up with:

```haskell
{{ file src/Main.hs }}
```

And the output from `cabal run`:
```
{{{{shellOutput nix-shell --run "cabal run"}}}}
```

Hopefully you've found this tutorial useful! Personally I'm happy to have finally gotten something simple working without battling the various types, something that scared me off from using persistent in the first place (and all those language extensions!).
