# Introduction

This tutorial is written with  [GitChapter](https://github.com/chrissound/GitChapter). This allows you to clone down the tutorial from <https://github.com/chrissound/HaskellPersistentTutorial>, and hack along from any chapter. You can checkout a specific chapter from any of the chapter commit references that are shown as: 

{{ gitCommitOffset }}

I decided to learn the Haskell persistent library, and what better way to learn something, than write a tutorial in the midst! So here you go! Bit of an experiment from my part.

Lets begin! I've based off this tutorial from <https://www.yesodweb.com/book/persistent> which is released under <https://creativecommons.org/licenses/by/4.0/> - which I'm very thankful for!

So we start off with a very simple example involving an in-memory sqlite database:

`package.yaml`
```
{{ file package.yaml }}
```

`Main.hs`
```haskell
{{ file src/Main.hs }}
```

Great so with the above setup we can run `cabal run` which outputs:
```
{{{{shellOutput nix-shell --run "cabal run"}}}}
```
