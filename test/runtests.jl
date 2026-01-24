# SPDX-License-Identifier: PMPL-1.0-or-later
using Test
using PolyglotFormalisms

@testset "PolyglotFormalisms.jl" begin
    include("arithmetic_tests.jl")
    include("comparison_tests.jl")
    include("logical_tests.jl")
    include("string_tests.jl")
end
