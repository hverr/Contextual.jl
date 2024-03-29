
struct Ctx1 end
struct Ctx2 end
@context Ctx1
@context Ctx2

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
        @test TinyCassette.execute(nothing, get_contextualized) == 0
        @test TinyCassette.execute(Ctx1(), get_contextualized) == 1
        @test TinyCassette.execute(Ctx2(), get_contextualized) == 2
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
        @test isa(TinyCassette.execute(Ctx1(), get_ctx1), Ctx1)
        @test isa(TinyCassette.execute(Ctx2(), get_ctx2), Ctx2)
    end
end
