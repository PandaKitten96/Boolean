# Boolean

[![Hackage](https://img.shields.io/hackage/v/Boolean.svg)](https://hackage.haskell.org/package/Boolean)
[![License: BSD3](https://img.shields.io/badge/License-BSD3-blue.svg)](COPYING)

Generalized boolean and number classes for Haskell.

## Overview

`Boolean` provides type classes for generalized boolean operations, allowing boolean-like behaviour to be abstracted over many types — not just `Bool`. This is useful when working with symbolic or lifted computations (e.g., shader languages, DSLs, or applicative functors).

## Modules

| Module | Description |
|---|---|
| `Data.Boolean` | Core type classes: `Boolean`, `IfB`, `EqB`, `OrdB` |
| `Data.Boolean.Overload` | Overloaded boolean operators |
| `Data.Boolean.Numbers` | Generalized numeric classes |

## Quick Start

```haskell
import Data.Boolean

-- Standard Bool still works
example1 :: Bool
example1 = true &&* false

-- Lifted if-then-else
example2 :: Int
example2 = ifB True 1 0

-- Generalized equality
example3 :: Bool
example3 = (42 :: Int) ==* 42
```

## Key Type Classes

- **`Boolean b`** — Generalizes `True`, `False`, `not`, `(&&)`, `(||)`
- **`IfB a`** — Generalizes `if-then-else` for any type with an associated boolean
- **`EqB a`** — Generalizes `(==)` and `(/=)` via `(==*)` and `(/=*)`
- **`OrdB a`** — Generalizes `(<)`, `(<=)`, `(>)`, `(>=)` via `(<*)`, `(<=*)`, etc.

## Building

```
cabal build
cabal test
```

## History

- Starting with **0.1.0**, this package uses type families.
- Up to **0.0.2**, it used MPTCs with functional dependencies.

Thanks to Andy Gill for suggesting the type families change, to Alex Horsman for `Data.Boolean.Overload`, and to Jan Bracker for `Data.Boolean.Numbers`.

## License

BSD3 — see [COPYING](COPYING) for details.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to contribute.

## Contact

See [CONTACT.md](CONTACT.md) for how to reach the maintainer.
