
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

    @testset "@contextual" begin
        function get_ctx1()::Ctx1
            return @contextual(Ctx1)
        end

        function get_ctx2()::Ctx2
            return @contextual(Ctx2)
        end

        @test_throws MethodError get_ctx1()
        @test_throws MethodError get_ctx2()
        @test isa(TinyCassette.Overdub(get_ctx1, Ctx1())(), Ctx1)
        @test isa(TinyCassette.Overdub(get_ctx2, Ctx2())(), Ctx2)
    end
end
