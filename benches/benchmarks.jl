# SPDX-License-Identifier: MPL-2.0
# (PMPL-1.0-or-later preferred; MPL-2.0 required for Julia ecosystem)
# BenchmarkTools benchmarks for PolyglotFormalisms.jl.

using BenchmarkTools
using PolyglotFormalisms

println("=== PolyglotFormalisms.jl Benchmarks ===")

# --- Arithmetic ---

println("\n-- Arithmetic --")

b_add      = @benchmark Arithmetic.add(42, 58)
b_subtract = @benchmark Arithmetic.subtract(100, 42)
b_multiply = @benchmark Arithmetic.multiply(12, 13)
b_divide   = @benchmark Arithmetic.divide(100.0, 4.0)
b_modulo   = @benchmark Arithmetic.modulo(100, 7)
println("add:      ", median(b_add))
println("subtract: ", median(b_subtract))
println("multiply: ", median(b_multiply))
println("divide:   ", median(b_divide))
println("modulo:   ", median(b_modulo))

# --- Logical ---

println("\n-- Logical --")

b_and = @benchmark Logical.and(true, false)
b_or  = @benchmark Logical.or(true, false)
b_not = @benchmark Logical.not(true)
println("and: ", median(b_and))
println("or:  ", median(b_or))
println("not: ", median(b_not))

# --- Comparison ---

println("\n-- Comparison --")

b_lt    = @benchmark Comparison.less_than(3, 5)
b_gt    = @benchmark Comparison.greater_than(5, 3)
b_equal = @benchmark Comparison.equal(4, 4)
println("less_than:    ", median(b_lt))
println("greater_than: ", median(b_gt))
println("equal:        ", median(b_equal))

# --- Collection ---

println("\n-- Collection --")

xs_small  = collect(1:10)
xs_medium = collect(1:100)
xs_large  = collect(1:10_000)

b_map_small  = @benchmark Collection.map_items(x -> x * 2, $xs_small)
b_map_medium = @benchmark Collection.map_items(x -> x * 2, $xs_medium)
b_map_large  = @benchmark Collection.map_items(x -> x * 2, $xs_large)
println("map_items (n=10):     ", median(b_map_small))
println("map_items (n=100):    ", median(b_map_medium))
println("map_items (n=10000):  ", median(b_map_large))

b_filter_small  = @benchmark Collection.filter_items(x -> x > 5, $xs_small)
b_filter_medium = @benchmark Collection.filter_items(x -> x > 50, $xs_medium)
println("filter_items (n=10):   ", median(b_filter_small))
println("filter_items (n=100):  ", median(b_filter_medium))

b_reduce_small  = @benchmark Collection.reduce_items((a, x) -> a + x, $xs_small, 0)
b_reduce_medium = @benchmark Collection.reduce_items((a, x) -> a + x, $xs_medium, 0)
println("reduce_items (n=10):   ", median(b_reduce_small))
println("reduce_items (n=100):  ", median(b_reduce_medium))

# --- StringOps ---

println("\n-- StringOps --")

b_concat_short = @benchmark StringOps.concat("hello", " world")
b_concat_long  = @benchmark StringOps.concat("a" ^ 1000, "b" ^ 1000)
b_length_short = @benchmark StringOps.length("hello world")
b_length_long  = @benchmark StringOps.length("a" ^ 10_000)
println("concat (short): ", median(b_concat_short))
println("concat (long):  ", median(b_concat_long))
println("length (short): ", median(b_length_short))
println("length (long):  ", median(b_length_long))
