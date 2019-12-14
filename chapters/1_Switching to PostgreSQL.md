# Switching to PostgreSQL

{{ gitCommitOffset }}

We can setup a simple postgres database with the following docker-compose config:

```haskell
{{ file extra/docker-compose.yaml }}
```


```
{{ gitDiff package.yaml }}
```

```haskell
{{ gitDiff src/Main.hs }}
```

Great so with the above setup we can run `cabal run` which outputs:
```
{{{{shellOutput nix-shell --run "cabal run"}}}}
```
