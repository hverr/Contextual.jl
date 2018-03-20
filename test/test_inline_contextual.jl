
struct Ctx1 end
struct Ctx2 end
Contextual.@context Ctx1
Contextual.@context Ctx2

@testset "inline contextual" begin

    @testset "@contextualized" begin
        function get_contextualized()::Int64
            if @contextualized(Ctx1)
                return 1
            elseif @contextualized(Ctx2)
                return 2
            else
                return 0
            end
        end

        @test get_contextualized() == 0
        @test TinyCassette.Overdub(get_contextualized)() == 0
        @test TinyCassette.Overdub(get_contextualized, Ctx1())() == 1
        @test TinyCassette.Overdub(get_contextualized, Ctx2())() == 2
    end

    #@testset "@contextual" begin
    #    function get_m1()::Metadata2
    #        return @contextual(Metadata2)
    #    end
    #    @test_throws AssertionError get_m1()

    #    # currently this crashes
    #    @test overdub(SomeCtx, get_m1, metadata=Metadata1())() <: Metadata1
    #end
end
