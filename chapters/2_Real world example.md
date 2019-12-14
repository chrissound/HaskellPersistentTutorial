# Real world example - updating a database record

{{ gitCommitOffset }}

Lets try make a simple function, that takes an `Int` and returns a `Maybe Person` function.

So in the initiual tutorial they were using a `get` function... However looking this function up in the Hackage index for `persistent-posgresql` (http://hackage.haskell.org/package/persistent-postgresql-2.10.1/docs/doc-index-All.html) has no link suprisingly? Probably some type hackery of some sort going on... Grr

Oh no actually it's just defined in the `persistent` hackage index (so maybe it's re-exported?).  http://hackage.haskell.org/package/persistent-2.10.4/docs/Database-Persist-Class.html#v:get


If we define a function as:

```
getUser :: Key Person -> ReaderT backend0 m0 ()
getUser x = do
  maybePerson <- get x
  case maybePerson of
      Nothing -> liftIO $ putStrLn "Just kidding, not really there"
      Just person -> liftIO $ print (person :: Person)
```

The above gives an error of:
```
    • Couldn't match type ‘BaseBackend backend0’ with 
‘SqlBackend’
        arising from a use of ‘get’
    • In a stmt of a 'do' block: maybePerson <- get x
      In the expression:
        do maybePerson <- get x
           case maybePerson of
             Nothing -> liftIO $ putStrLn "Just kidding, not 
really there"
             Just person -> liftIO $ print (person :: Person)
```

Googling this error shows up with a stackoverflow question I literally posted nearly 2+ years ago... (My last attempt with persistent ahem...)

Okay so taking the suggestion from stackoveflow we end up with:
```
getUser :: Key Person -> ReaderT SqlBackend m ()
```

Which errors with a missing monad instance for `m`... So filling those out we end up with:
```
getUser :: (MonadIO m) => Key Person -> ReaderT SqlBackend m ()
```

Yay!!! But wait we wanted an `Int` as input... 

Hoogle shows 0 results for:

```
Int -> Key +persistent
Int -> Key +persistent-postgresql
```
A quick web search shows up with  https://stackoverflow.com/questions/28068447/haskell-persistent-how-get-entity-from-db-by-key-if-i-have-key-in-integer-varia

Which points to use the following function:

http://www.stackage.org/haddock/lts-1.2/persistent-2.1.1.4/Database-Persist-Sql.html#v:toSqlKey

```
toSqlKey :: ToBackendKey SqlBackend record => Int64 -> Key record
```

AND FINALLY we end up with:
```
getUser :: (MonadIO m) => Int -> ReaderT SqlBackend m ()
getUser x = do
  maybePerson <- get $ toSqlKey x
  case maybePerson of
      Nothing -> liftIO $ putStrLn "Just kidding, not really there"
      Just person -> liftIO $ print (person :: Person)
```

Which errors with:
```
    • Couldn't match expected type ‘GHC.Int.Int64’
                  with actual type ‘Int’
    • In the first argument of ‘toSqlKey’, namely 
‘x’
```

Which we can use `fromIntegral` to fix, though I'm not 100% sure of any potential limitations due to it.

----

So to summarize this chapter we've ended up with:

```haskell
{{ file src/Main.hs }}
```

```haskell
{{ file src/User.hs }}
```

```
{{ gitDiff package.yaml }}
```


And the output from `cabal run`:
```
{{{{shellOutput nix-shell --run "cabal run"}}}}
```
