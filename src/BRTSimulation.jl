module BRTSimulation

include("./Map.jl")

function move_bus!(map::Map)
    road_size = size(map.road)[2]
    for bus in map.buses
        next_pos = ((bus.speed + bus.actual_map_pos-1) % road_size) == 0 ? 1 : ((bus.speed + bus.actual_map_pos-1) % road_size)
        if map.road[1,next_pos] isa EmptyCell
            aux = map.road[1,next_pos]
            map.road[1,next_pos] = bus
            map.road[1, bus.actual_map_pos] = aux
            bus.actual_map_pos = next_pos
        end
    end
end

function calculating_next_speed(map::Map)
    buses = map.buses
    road_size = size(map.road)[2]
    sort!(buses)
    println(buses)
    n_buses = size(buses)[1]
    for i in 1:n_buses
        bus = buses[i]
        new_speed = Constants.MAX_SPEED
        next_bus = buses[next_index(i,n_buses)]
        println("\n BUS $(bus.id) IS BEING ITERATED OVER NEXT BUS $(next_bus.id)\n")
        if bus.actual_map_pos < next_bus.actual_map_pos
            new_speed = next_bus.actual_map_pos-1
            if new_speed > Constants.MAX_SPEED println("WELL BUS $(bus.id) IS OVER SPEEDING IN IF\n") end
        elseif next_bus != bus
            local possible_speed = next_bus.actual_map_pos + road_size - 1
            new_speed = possible_speed < Constants.MAX_SPEED ? possible_speed : Constants.MAX_SPEED
            if new_speed > Constants.MAX_SPEED println("WELL BUS $(bus.id) IS OVER SPEEDING IN ELSE\n") end
        end
        bus.speed = new_speed
    end
end

function update() # should update the road based on the speed of the 
end

function control_map(map::Map)
end

end # module