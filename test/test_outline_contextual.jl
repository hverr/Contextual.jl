
struct Int64Ctx
    value::Int64
end
@context Int64Ctx

@testset "outline contextual" begin

    f(r) = r+3

    @contextualized function f(r) @with {offset::Int64Ctx}
        x = r + offset.value
        return x
    end

    @test f(2) == 5
    @test (@withctx Int64Ctx(5) f(2)) == 7
end

abstract type OutlineTypeA end
struct OutlineTypeB <: OutlineTypeA end

@testset "outline contextual subtype" begin
    g() = 0

    @contextualized function g() @with {ctx<:OutlineTypeA}
        1
    end

    @test g() == 0
    @test (@withctx OutlineTypeB() g()) == 1
end
