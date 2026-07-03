.PHONY: build test haddock clean

build:
	cabal build

test:
	cabal test --enable-tests

haddock:
	cabal haddock

clean:
	cabal clean
