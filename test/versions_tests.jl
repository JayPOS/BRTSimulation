@testset "Correctness" begin
    map1 = BRTSimulation.parallel_v1()
    map2 = BRTSimulation.parallel_v2()
    map3 = BRTSimulation.sequential()

    @testset "Maps" begin
        @testset "Buses" begin
            @test length(map3.buses) == length(map2.buses) == length(map1.buses)
            for i in 1:length(map3.buses)
                @test map3.buses[i].id == map2.buses[i].id == map1.buses[i].id 
                @test map3.buses[i].actual_map_pos == map2.buses[i].actual_map_pos == map1.buses[i].actual_map_pos 
            end
        end
    end
end