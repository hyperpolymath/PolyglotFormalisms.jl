# SPDX-License-Identifier: MPL-2.0
# (PMPL-1.0-or-later preferred; MPL-2.0 required for Julia ecosystem)
# Property-based invariant tests for PolyglotFormalisms.jl.
# Checks algebraic laws across Arithmetic, Logical, Comparison, Collection, and StringOps.

using Test
using PolyglotFormalisms

@testset "Property-Based Tests" begin

    @testset "Arithmetic: add is commutative" begin
        for _ in 1:50
            a, b = rand(-1000:1000), rand(-1000:1000)
            @test Arithmetic.add(a, b) == Arithmetic.add(b, a)
        end
    end

    @testset "Arithmetic: add is associative" begin
        for _ in 1:50
            a, b, c = rand(-100:100), rand(-100:100), rand(-100:100)
            @test Arithmetic.add(Arithmetic.add(a, b), c) ==
                  Arithmetic.add(a, Arithmetic.add(b, c))
        end
    end

    @testset "Arithmetic: multiply is commutative" begin
        for _ in 1:50
            a, b = rand(-100:100), rand(-100:100)
            @test Arithmetic.multiply(a, b) == Arithmetic.multiply(b, a)
        end
    end

    @testset "Arithmetic: multiply distributes over add" begin
        for _ in 1:50
            a, b, c = rand(-50:50), rand(-50:50), rand(-50:50)
            lhs = Arithmetic.multiply(a, Arithmetic.add(b, c))
            rhs = Arithmetic.add(Arithmetic.multiply(a, b), Arithmetic.multiply(a, c))
            @test lhs == rhs
        end
    end

    @testset "Arithmetic: subtract is inverse of add" begin
        for _ in 1:50
            a, b = rand(-500:500), rand(-500:500)
            @test Arithmetic.subtract(Arithmetic.add(a, b), b) == a
        end
    end

    @testset "Arithmetic: modulo range constraint (positive divisor)" begin
        for _ in 1:50
            a = rand(0:9999)
            b = rand(1:100)
            r = Arithmetic.modulo(a, b)
            @test 0 <= r < b
        end
    end

    @testset "Logical: and is commutative" begin
        for _ in 1:50
            a, b = rand(Bool), rand(Bool)
            @test Logical.and(a, b) == Logical.and(b, a)
        end
    end

    @testset "Logical: or is commutative" begin
        for _ in 1:50
            a, b = rand(Bool), rand(Bool)
            @test Logical.or(a, b) == Logical.or(b, a)
        end
    end

    @testset "Logical: de Morgan's law — not(and(a,b)) == or(not(a), not(b))" begin
        for _ in 1:50
            a, b = rand(Bool), rand(Bool)
            @test Logical.not(Logical.and(a, b)) ==
                  Logical.or(Logical.not(a), Logical.not(b))
        end
    end

    @testset "Comparison: less_than and greater_than are antisymmetric" begin
        for _ in 1:50
            a, b = rand(-1000:1000), rand(-1000:1000)
            if a != b
                @test Comparison.less_than(a, b) != Comparison.greater_than(a, b)
            end
        end
    end

    @testset "Collection: map_items preserves length" begin
        for _ in 1:50
            n = rand(0:20)
            xs = rand(Int, n)
            result = Collection.map_items(x -> x * 2, xs)
            @test length(result) == n
        end
    end

    @testset "StringOps: concat length equals sum of parts" begin
        strs = ["", "a", "hello", "world", "julia", "polyglot"]
        for _ in 1:50
            s1 = rand(strs)
            s2 = rand(strs)
            @test StringOps.length(StringOps.concat(s1, s2)) ==
                  StringOps.length(s1) + StringOps.length(s2)
        end
    end

    @testset "StringOps: concat with empty string is identity" begin
        strs = ["hello", "world", "test", "julia"]
        for _ in 1:50
            s = rand(strs)
            @test StringOps.concat(s, "") == s
            @test StringOps.concat("", s) == s
        end
    end

end
