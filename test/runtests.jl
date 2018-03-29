using Contextual
using TinyCassette

using Test: @testset, @test, @test_throws

@testset "Contextual" begin
    include("test_inline_contextual.jl")
    include("test_outline_contextual.jl")
end
