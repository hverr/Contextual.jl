
struct Int64Ctx
    value::Int64
end
@context Int64Ctx

struct Int64TypeVarCtx{V} end
@context Int64TypeVarCtx

@testset "outline contextual" begin

    f(r) = r+3

    @contextualized function f(r) @with {offset::Int64Ctx}
        x = r + offset.value
        return x
    end

    @test f(2) == 5
    @test (@withctx Int64Ctx(5) f(2)) == 7
end

@testset "outline contextual (inline)" begin

    f(r) = r+3

    @inline @contextualized function f(r) @with {offset::Int64Ctx}
        x = r + offset.value
        return x
    end

    @test f(2) == 5
    @test (@withctx Int64Ctx(5) f(2)) == 7
end

@testset "outline contextual (short)" begin

    f(r) = r+3

    @contextualized f(r) = (@with {offset::Int64Ctx}; r + offset.value)

    @test f(2) == 5
    @test (@withctx Int64Ctx(5) f(2)) == 7
end

@testset "outline contextual (short, inline)" begin

    f(r) = r+3

    @inline @contextualized f(r) = (@with {offset::Int64Ctx}; r + offset.value)

    @test f(2) == 5
    @test (@withctx Int64Ctx(5) f(2)) == 7
end

@testset "outline contextual without context assignment" begin
    g() = 0

    @contextualized function g() @with {_::Int64Ctx}
        1
    end

    @test g() == 0
    @test (@withctx Int64Ctx(5) g()) == 1
end

@testset "outline contextual without context assignment (short)" begin
    g() = 0

    @contextualized g() = (@with {_::Int64Ctx}; 1)

    @test g() == 0
    @test (@withctx Int64Ctx(5) g()) == 1
end

@testset "outline contextual with access to type" begin
    g() = 0
    @contextualized function g() where {V}
        @with {_ :: Int64TypeVarCtx{V}}
        V
    end

    @test g() == 0
    @test (@withctx Int64TypeVarCtx{3}() g()) == 3
end

@testset "outline contextual with access to type (short)" begin
    g() = 0
    @contextualized g() where {V} = (@with {_ :: Int64TypeVarCtx{V}}; V)

    @test g() == 0
    @test (@withctx Int64TypeVarCtx{3}() g()) == 3
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

@testset "outline contextual subtype (short)" begin
    g() = 0

    @contextualized g() = (@with {ctx<:OutlineTypeA}; 1)

    @test g() == 0
    @test (@withctx OutlineTypeB() g()) == 1
end
