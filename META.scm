;; SPDX-License-Identifier: PMPL-1.0-or-later
;; META.scm for PolyglotFormalisms.jl
;; Meta-level information: architecture, philosophy, governance

(define-meta polyglot-formalisms-meta
  (version "1.0.0")
  (media-type "application/meta+scheme")

  ;; Architecture Decision Records
  (architecture-decisions
    (adr
      (id "adr-001")
      (title "Use Julia as reference implementation language")
      (status "accepted")
      (date "2025-01-23")
      (context "Need to choose a language for the formally verified reference implementation of aggregate-library. Options considered: Julia, Coq, Lean, Agda, Idris2, OCaml. Requirements: executable code, formal verification support, readable by non-specialists, good numeric/string/collection support, interop with SMT solvers.")
      (decision "Use Julia as the reference implementation language. Julia provides: (1) executable, performant code, (2) strong type system with multiple dispatch, (3) planned integration with Axiom.jl for formal verification, (4) readable syntax close to mathematical notation, (5) excellent numeric and collection support, (6) growing formal methods ecosystem.")
      (consequences "Positive: Julia code is executable and testable immediately. Readable by mathematicians and programmers. Good ecosystem for numeric/symbolic computation. Negative: Formal verification tooling less mature than Coq/Lean. Requires building Axiom.jl integration. Julia package ecosystem smaller than Python/JavaScript."))

    (adr
      (id "adr-002")
      (title "Property-based verification over proof-carrying code")
      (status "accepted")
      (date "2025-01-23")
      (context "Need to decide verification approach: property-based testing with eventual formal proofs vs. proof-carrying code (Coq extraction). aggregate-library needs to be implementable in languages without dependent types (ReScript, Elixir, JavaScript).")
      (decision "Use property-based verification: implement operations normally, document proven properties in comments, add @prove macros when Axiom.jl available. This allows: (1) implementations in languages without dependent types, (2) gradual adoption of formal verification, (3) readable code that doesn't require theorem proving expertise.")
      (consequences "Positive: Can implement in ReScript/Gleam/Elixir without proof extraction. Code remains readable. Formal proofs added incrementally. Negative: Properties not verified until Axiom.jl integration complete. Requires discipline to maintain correspondence between code and properties."))

    (adr
      (id "adr-003")
      (title "Exact specification conformance over idiomatic Julia")
      (status "accepted")
      (date "2025-01-23")
      (context "Should we write idiomatic Julia code (using built-in operators, standard names) or exactly match aggregate-library specification (verbose names like 'add', 'subtract')? Tension between Julia conventions and cross-language consistency.")
      (decision "Exactly match aggregate-library specification names and signatures. Use add/subtract/multiply instead of +/-/*. This ensures: (1) test cases transfer directly across languages, (2) semantic equivalence verification is unambiguous, (3) ReScript/Gleam/Julia code looks similar.")
      (consequences "Positive: Perfect specification conformance. Easy to verify equivalence across languages. Negative: Not idiomatic Julia. Users familiar with Julia may find verbose. Could add operator aliases in future for convenience."))

    (adr
      (id "adr-004")
      (title "Comprehensive property testing over minimal test cases")
      (status "accepted")
      (date "2025-01-23")
      (context "aggregate-library specification provides 5-10 example test cases per operation. Should we include only these, or add comprehensive property tests (commutativity, associativity, identity, etc.)? Trade-off between specification minimalism and verification thoroughness.")
      (decision "Include comprehensive property tests in addition to specification conformance tests. Each operation gets: (1) all test cases from aggregate-library spec, (2) property tests for mathematical properties, (3) edge case tests (divide by zero, empty strings, etc.). Property tests will become @prove statements when Axiom.jl integrated.")
      (consequences "Positive: Thorough verification. Properties documented in test form. Easy migration to formal proofs. Negative: Test suite much larger than minimal spec (287 tests vs ~50 spec examples). More maintenance burden."))

    (adr
      (id "adr-005")
      (title "Module structure mirrors specification sections")
      (status "accepted")
      (date "2025-01-23")
      (context "Should we organize code by Julia conventions (single module with all operations) or mirror aggregate-library structure (separate modules for Arithmetic, Comparison, Logical, String, Collection, Conditional)?")
      (decision "Mirror aggregate-library structure with separate modules. This ensures: (1) direct correspondence between spec and code, (2) clear boundaries for verification, (3) modules can be independently proven correct, (4) easier for users to navigate parallel implementations in other languages.")
      (consequences "Positive: Structure matches specification exactly. Easy cross-language comparison. Modular verification. Negative: More verbose imports. Not typical Julia style (which favors flatter structure)."))

    (adr
      (id "adr-006")
      (title "Test as stdlib dependency until v1.0")
      (status "accepted")
      (date "2025-01-23")
      (context "Julia convention puts Test in [extras] for library packages. However, during active development, having Test as regular dependency simplifies testing and matches development workflow.")
      (decision "Keep Test as regular [deps] dependency until v1.0.0 release. Move to [extras] with proper [targets] section for v1.0. This allows rapid iteration during development without package structure overhead.")
      (consequences "Positive: Simpler development workflow. Matches current phase (active development, not stable library). Negative: Not idiomatic for released packages. Must remember to refactor for v1.0. Note: Issue documented in STATE.scm as medium-priority blocker."))

    (adr
      (id "adr-007")
      (title "Defer Axiom.jl integration until Axiom reaches v0.3")
      (status "accepted")
      (date "2025-01-23")
      (context "Axiom.jl formal verification system is at v0.1 and still under development. Should we integrate immediately or wait for stability? Risk of breaking changes vs. benefit of early formal verification.")
      (decision "Defer Axiom.jl integration until Axiom reaches v0.3.0. For now: (1) document properties in comments, (2) test properties in test suite, (3) design code to accommodate future @prove macros, (4) maintain empty @prove comment placeholders. This avoids coupling to unstable API while preparing for integration.")
      (consequences "Positive: Avoid breaking changes as Axiom.jl evolves. Code structure ready for integration. Negative: Properties not formally proven yet. May need refactoring when Axiom.jl integration happens. Must manually maintain property documentation."))

    (adr
      (id "adr-008")
      (title "PMPL-1.0-or-later license for academic accessibility")
      (status "accepted")
      (date "2025-01-23")
      (context "Need to choose license that allows: (1) academic research use, (2) open source development, (3) potential commercialization protection, (4) compatibility with hyperpolymath ecosystem. Options: MIT, Apache-2.0, AGPL-3.0, PMPL-1.0.")
      (decision "Use PMPL-1.0-or-later (Palimpsest Meta-Public License). This provides: (1) open source with copyleft, (2) academic research friendly, (3) meta-licensing framework allowing evolution, (4) consistency with other hyperpolymath projects, (5) protection against proprietary capture.")
      (consequences "Positive: Aligns with ecosystem licensing. Academic-friendly. Meta-license allows adaptation. Negative: Less well-known than MIT/Apache. May require explanation to contributors. Some commercial users may prefer permissive licenses.")))

  ;; Development practices
  (development-practices
    (code-style
      (formatter "JuliaFormatter.jl")
      (style "default")
      (conventions
        "Function names exactly match aggregate-library specification"
        "All operations have docstrings with Interface Signature section"
        "Properties documented in comments (will become @prove)"
        "Test files mirror source files (arithmetic.jl → arithmetic_tests.jl)"
        "SPDX headers on all files"))

    (security
      (policy "SECURITY.md defines vulnerability reporting process")
      (practices
        "All dependencies pinned with compat bounds"
        "No eval or meta-programming that executes strings"
        "Division by zero returns Inf (IEEE 754) not error (for divide)"
        "Modulo by zero throws DivideError (Julia convention)"
        "No unsafe FFI calls"))

    (testing
      (framework "Test stdlib")
      (coverage "287 tests covering 4 modules")
      (test-structure
        "Conformance tests (match aggregate-library spec exactly)"
        "Property tests (mathematical properties)"
        "Edge case tests (zero, negative, empty, etc.)")
      (run-command "julia --project=. -e 'using Pkg; Pkg.test()'"))

    (versioning
      (scheme "Semantic Versioning 2.0.0")
      (current "0.2.0")
      (v1-requirements
        "All six modules implemented"
        "Axiom.jl integration complete with @prove macros"
        "Cross-language verification workflow documented"
        "Julia General registry registration")
      (breaking-changes-allowed-until "v1.0.0"))

    (documentation
      (primary "README.md")
      (in-code "Comprehensive docstrings")
      (examples "Usage examples in README and docstrings")
      (verification-docs "Planned: verification workflow guide")
      (media-type "text/x-markdown"))

    (branching
      (main-branch "main")
      (strategy "trunk-based development")
      (protection "No direct commits to main after v1.0")
      (releases "Tagged on main with GitHub releases")))

  ;; Design rationale
  (design-rationale
    (why-julia
      "Julia chosen for: (1) mathematical notation proximity, (2) strong type system, (3) formal verification integration via Axiom.jl, (4) executable reference implementation, (5) excellent numeric/symbolic support.")

    (why-exact-spec-match
      "Code exactly matches aggregate-library specification to enable unambiguous semantic equivalence verification across languages. Idiomatic Julia would make cross-language comparison ambiguous.")

    (why-property-tests
      "Property tests document mathematical invariants that will become formal proofs. They provide verification until Axiom.jl integration complete and serve as specification for @prove macros.")

    (why-modular-structure
      "Separate modules (Arithmetic, Comparison, etc.) mirror specification structure, enabling modular verification and clear correspondence with specification sections.")

    (why-defer-axiom
      "Axiom.jl is v0.1 and API unstable. Deferring integration until v0.3 avoids coupling to breaking changes while preparing code structure for eventual integration.")

    (why-pmpl-license
      "PMPL-1.0-or-later chosen for: (1) copyleft protection, (2) academic accessibility, (3) ecosystem consistency, (4) meta-licensing framework for evolution.")

    (why-reference-implementation
      "As reference implementation, correctness and clarity prioritized over performance. Julia's speed sufficient for verification workflows while maintaining readability.")))

;; Governance (minimal for now)
(define (get-maintainer)
  "Primary maintainer"
  "Jonathan D.A. Jewell <jonathan.jewell@open.ac.uk>")

(define (contribution-model)
  "Contribution guidelines"
  "See CONTRIBUTING.md. All contributions must: (1) match aggregate-library spec exactly, (2) include property tests, (3) pass existing test suite, (4) include docstrings with Interface Signature section.")

(define (decision-process)
  "How architectural decisions made"
  "Maintainer makes decisions after community discussion. ADRs documented in META.scm. Breaking changes require ADR and community notice.")

(define (v1-release-criteria)
  "Requirements for v1.0.0 release"
  '("All six modules implemented (Collection, Conditional remaining)"
    "Axiom.jl integration complete with @prove macros"
    "Cross-language verification workflow documented with examples"
    "Test in [extras] not [deps]"
    "Julia General registry registration"
    "At least one complete cross-language equivalence proof"))
