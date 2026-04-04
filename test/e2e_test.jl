# SPDX-License-Identifier: MPL-2.0
# (PMPL-1.0-or-later preferred; MPL-2.0 required for Julia ecosystem)
# E2E pipeline tests for PolyglotFormalisms.jl.
# Tests cross-module pipelines: arithmetic → logical → collection → string operations.

using Test
using PolyglotFormalisms

@testset "E2E Pipeline Tests" begin

    @testset "Full pipeline: arithmetic → logical decision" begin
        # Compute values and make logical decisions about them.
        a = Arithmetic.add(10, 5)       # 15
        b = Arithmetic.multiply(3, 5)   # 15
        equal = Comparison.equal(a, b)
        @test equal == true

        c = Arithmetic.divide(100.0, 4.0)   # 25.0
        d = Arithmetic.subtract(30.0, 5.0)  # 25.0
        @test Comparison.equal(c, d) == true

        # Logical composition of comparison results.
        r1 = Comparison.greater_than(Arithmetic.add(10, 1), 10)
        r2 = Comparison.less_than(Arithmetic.subtract(10, 1), 10)
        @test Logical.and(r1, r2) == true
    end

    @testset "Full pipeline: collection → arithmetic aggregation" begin
        # Map arithmetic over a collection, then aggregate.
        nums = [1, 2, 3, 4, 5]
        doubled = Collection.map_items(x -> Arithmetic.multiply(x, 2), nums)
        @test doubled == [2, 4, 6, 8, 10]

        # Filter to even numbers (those whose modulo by 2 is 0).
        evens = Collection.filter_items(x -> Arithmetic.modulo(x, 2) == 0, nums)
        @test evens == [2, 4]

        # Reduce to sum via repeated addition.
        total = Collection.reduce_items((acc, x) -> Arithmetic.add(acc, x), nums, 0)
        @test total == 15
    end

    @testset "Full pipeline: string → collection pipeline" begin
        words = ["hello", "world", "julia", "polyglot"]
        # Map string operations over collection.
        lengths = Collection.map_items(w -> StringOps.length(w), words)
        @test lengths == [5, 5, 5, 8]

        # Build a concatenated string from all words.
        joined = Collection.reduce_items(
            (acc, w) -> StringOps.concat(acc, StringOps.concat(" ", w)),
            words[2:end],
            words[1]
        )
        @test StringOps.length(joined) > 0
        @test contains(joined, "hello")
    end

    @testset "Full pipeline: conditional logic with arithmetic" begin
        x = Arithmetic.add(3, 4)   # 7
        # Check x > 5: if so, multiply by 2, else return 0.
        is_big = Comparison.greater_than(x, 5)
        result = Conditional.if_then_else(is_big, Arithmetic.multiply(x, 2), 0)
        @test result == 14

        y = Arithmetic.subtract(3, 2)  # 1
        is_big2 = Comparison.greater_than(y, 5)
        result2 = Conditional.if_then_else(is_big2, Arithmetic.multiply(y, 2), 0)
        @test result2 == 0
    end

    @testset "Error handling: division by zero returns Inf (IEEE 754)" begin
        result = Arithmetic.divide(1.0, 0.0)
        @test isinf(result)
    end

    @testset "Error handling: modulo by zero throws DivideError" begin
        @test_throws DivideError Arithmetic.modulo(5, 0)
    end

    @testset "Round-trip consistency: arithmetic inverse operations" begin
        for _ in 1:20
            n = rand(1:100)
            m = rand(1:100)
            # subtract undoes add.
            @test Arithmetic.subtract(Arithmetic.add(n, m), m) == n
            # add undoes subtract.
            @test Arithmetic.add(Arithmetic.subtract(n, m), m) == n
        end
    end

    @testset "Round-trip consistency: string concat and length" begin
        words = ["alpha", "beta", "gamma"]
        for i in 1:length(words)-1
            joined = StringOps.concat(words[i], words[i+1])
            @test StringOps.length(joined) ==
                  StringOps.length(words[i]) + StringOps.length(words[i+1])
        end
    end

end
