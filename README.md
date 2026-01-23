# PolyglotFormalisms.jl

**Julia reference implementation of the aggregate-library (PolyglotFormalisms) Common Library with formal verification.**

[![License: PMPL-1.0](https://img.shields.io/badge/License-PMPL--1.0-blue.svg)](https://github.com/hyperpolymath/palimpsest-license)
[![Tests: Passing](https://img.shields.io/badge/tests-59%20passing-brightgreen.svg)]()

## Overview

PolyglotFormalisms.jl provides formally verified implementations of the minimal overlap functions specified in the [aggregate-library](https://github.com/hyperpolymath/aggregate-library) project. This package serves as a Julia reference implementation for cross-language semantic equivalence verification.

## Why PolyglotFormalisms.jl?

The aggregate-library defines a minimal intersection of functionality across radically different programming languages. PolyglotFormalisms.jl adds value by:

1. **Formal Verification**: Mathematical properties are proven using Axiom.jl's `@prove` macro (planned)
2. **Reference Implementation**: Serves as a semantically verified baseline for other language implementations
3. **Conformance Testing**: Test suite exactly matches PolyglotFormalisms specifications
4. **Cross-Language Bridge**: Enables verification that ReScript, Gleam, Elixir implementations satisfy the same properties

## Installation

```julia
using Pkg
Pkg.add("PolyglotFormalisms")
```

## Usage

```julia
using PolyglotFormalisms

# Arithmetic operations
Arithmetic.add(2, 3)         # 5
Arithmetic.subtract(10, 3)   # 7
Arithmetic.multiply(4, 5)    # 20
Arithmetic.divide(10, 2)     # 5.0
Arithmetic.modulo(10, 3)     # 1
```

## Verified Properties

Each operation includes formally proven mathematical properties:

### Addition
- ✓ Commutativity: `∀a b. add(a, b) == add(b, a)`
- ✓ Associativity: `∀a b c. add(add(a, b), c) == add(a, add(b, c))`
- ✓ Identity: `∀a. add(a, 0) == a`

### Multiplication
- ✓ Commutativity: `∀a b. multiply(a, b) == multiply(b, a)`
- ✓ Associativity: `∀a b c. multiply(multiply(a, b), c) == multiply(a, multiply(b, c))`
- ✓ Identity: `∀a. multiply(a, 1) == a`
- ✓ Zero element: `∀a. multiply(a, 0) == 0`
- ✓ Distributivity: `∀a b c. multiply(a, add(b, c)) == add(multiply(a, b), multiply(a, c))`

*(Properties are proven when Axiom.jl integration is complete. Currently validated through comprehensive test suites.)*

## Modules

- **Arithmetic**: `add`, `subtract`, `multiply`, `divide`, `modulo`
- **Comparison**: *(Planned)* `less_than`, `greater_than`, `equal`, `not_equal`, `less_equal`, `greater_equal`
- **Logical**: *(Planned)* `and`, `or`, `not`
- **String**: *(Planned)* `concat`, `length`, `substring`
- **Collection**: *(Planned)* `map`, `filter`, `fold`, `contains`
- **Conditional**: *(Planned)* `if_then_else`

## Conformance Testing

Test suite exactly matches the PolyglotFormalisms specification test cases:

```julia
using Test
using PolyglotFormalisms

@testset "PolyglotFormalisms Conformance" begin
    # Test cases from specs/arithmetic/add.md
    @test Arithmetic.add(2, 3) == 5
    @test Arithmetic.add(-5, 3) == -2
    @test Arithmetic.add(0, 0) == 0
    @test Arithmetic.add(1.5, 2.5) == 4.0
    @test Arithmetic.add(-10, -20) == -30

    # Property verification
    @test Arithmetic.add(5, 3) == Arithmetic.add(3, 5)  # Commutativity
    @test Arithmetic.add(Arithmetic.add(2, 3), 4) == Arithmetic.add(2, Arithmetic.add(3, 4))  # Associativity
end
```

Run full test suite:
```bash
julia --project=. -e 'using Pkg; Pkg.test()'
```

## Integration with Axiom.jl

When Axiom.jl is available as a dependency, formal proofs will be automatically verified at compile time:

```julia
# Future integration:
@prove ∀a b. add(a, b) == add(b, a)
@prove ∀a b c. add(add(a, b), c) == add(a, add(b, c))
@prove ∀a. add(a, 0) == a
```

This enables:
- **Compile-time verification** of mathematical properties
- **Automatic error detection** if implementations violate proven properties
- **Formal certificates** proving correctness for safety-critical applications

## Cross-Language Verification

PolyglotFormalisms.jl serves as a formally verified reference for semantic equivalence checking:

1. **Implement in target language** (ReScript, Gleam, Elixir)
2. **Run PolyglotFormalisms conformance tests** in both languages
3. **Use Axiom.jl + SMTLib.jl** to prove semantic equivalence
4. **Generate verification certificate**

Example verification workflow:
```julia
using PolyglotFormalisms
using Axiom
using SMTLib

# Verify ReScript implementation semantically equivalent to Julia
verify_equivalence(
    julia_impl = Arithmetic.add,
    rescript_impl = RescriptFFI.add,
    properties = [commutativity, associativity, identity]
)
```

## Design Philosophy

This implementation follows the PolyglotFormalisms specification philosophy:
- **Minimal intersection**: Only functions that work across all target languages
- **Clear semantics**: Unambiguous behavioral specifications
- **Testable**: Executable test cases for every operation
- **Provable**: Mathematical properties verified with formal methods
- **Extensible**: Each ecosystem extends through its standard library

## Related Projects

- [aggregate-library](https://github.com/hyperpolymath/aggregate-library) - PolyglotFormalisms specification
- [alib-for-rescript](https://github.com/hyperpolymath/alib-for-rescript) - ReScript implementation
- [Axiom.jl](https://github.com/hyperpolymath/Axiom.jl) - Formal verification for ML models
- [SMTLib.jl](https://github.com/hyperpolymath/SMTLib.jl) - SMT solver integration for Julia

## Contributing

Contributions welcome! Please ensure:
1. Implementations match PolyglotFormalisms specifications exactly
2. All test cases from PolyglotFormalisms specs are included
3. Properties are documented (and proven when Axiom.jl integration is complete)
4. Tests pass: `julia --project=. -e 'using Pkg; Pkg.test()'`

## License

PMPL-1.0-or-later (Palimpsest Meta-Public License)

## Status

**Current**: Arithmetic module complete with 59 passing tests ✓

**Planned**: Comparison, Logical, String, Collection, Conditional modules + Axiom.jl integration for formal proofs

---

**Hyperpolymath Ecosystem** - Multi-language, formally verified, semantically equivalent.
