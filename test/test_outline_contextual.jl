
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
    @test TinyCassette.Overdub(f, Int64Ctx(5))(2) == 7
end
