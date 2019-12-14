#!/usr/bin/env bash
if which nix; then
    nix-shell --run "ghcid --command='cabal v2-repl app' --test=Main.main"
    exit 0
elif which stack; then
    ghcid '--command=stack ghci' --test='Main.main'
    exit 0
fi
