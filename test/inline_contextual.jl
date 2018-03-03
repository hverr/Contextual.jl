using Test: @test, @test_throws

using Cassette: overdub

using Contextual
using Contextual: @contextualized, @contextual

Contextual.@context SomeCtx

struct Metadata1 end
struct Metadata2 end

function test_contextualized()
    function is_contextualized()::Int64
        if @contextualized(Metadata1)
            return 0
        elseif @contextualized(Metadata2)
            return 1
        else
            return 2
        end
    end

    @test overdub(SomeCtx, is_contextualized, metadata=Metadata1())() == 0
    @test overdub(SomeCtx, is_contextualized, metadata=Metadata2())() == 1
    @test overdub(SomeCtx, is_contextualized)() == 2
    @test is_contextualized() == 2
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
println("testing @contextual")
test_contextual()
