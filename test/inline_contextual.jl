using Test: @test, @test_throws

using TinyCassette
using TinyCassette: Overdub

using Contextual
using Contextual: @contextualized, @contextual

struct Ctx1 end
struct Ctx2 end
Contextual.@context Ctx1
Contextual.@context Ctx2

function test_contextualized()
    function get_contextualized()::Int64
        @which Contextual.is_contextualized(Ctx1)
        if @contextualized(Ctx1)
            return 1
        elseif @contextualized(Ctx2)
            return 2
        else
            return 0
        end
    end

    @test get_contextualized() == 0
    @test Overdub(get_contextualized)() == 0
    #@code_lowered Overdub(get_contextualized)()
    #@test Overdub(get_contextualized, Ctx2())() == 1
    #@test Overdub(get_contextualized, Ctx2())() == 2
end

function test_contextual()
    function get_m1()::Metadata2
        return @contextual(Metadata2)
    end
    @test_throws AssertionError get_m1()

    # currently this crashes
    @test overdub(SomeCtx, get_m1, metadata=Metadata1())() <: Metadata1
end

println("testing @contextualized")
test_contextualized()

#println("testing @contextual")
#test_contextual()
