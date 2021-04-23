module BRTSimulation

include("./Map.jl")

function add_bus(map::Map) # add always in the beginning
    if map.road[1,1] == Constants.EMPTY
        new_bus = create_bus(map.id_counter)
        define_route(new_bus, map)
        map.id_counter += 1
        map.road[1,1] = 1
        push!(map.buses, new_bus)
        println("Recente added bus with id $(new_bus.id)")
    else
        println("Invalid Operation! First Position of road is occupied")
    end
end

function move_bus!(map::Map)
    road_size = size(map.road)[2]

    copy_road = copy(map.road)

    for bus in map.buses
        next_pos = bus.actual_map_pos + bus.speed
        # println(" HERE Pos: $(bus.actual_map_pos) Speed: $(bus.speed) BUSID: $(bus.id)")
        if next_pos > road_size
            aux_next_pos = next_pos
            next_pos = aux_next_pos - road_size
            # println(" HERE NextPOS: $(next_pos)  roadSize: $(road_size)")
        end
        if copy_road[1,next_pos] == Constants.EMPTY
            map.road[bus.flag, next_pos] = Constants.BUS
            map.road[bus.flag, bus.actual_map_pos] = Constants.EMPTY
            bus.actual_map_pos = next_pos
        elseif next_pos != bus.actual_map_pos
            println("Target Position not empty! || Bus_ID: $(bus.id)")
        end
    end
end

function calculating_next_speed(map::Map)
    buses = map.buses
    sort!(buses)
    new_speed = Constants.MAX_SPEED
    for id in 1:length(buses)
        id_next = id+1>length(buses) ? 1 : id+1
        if id_next > id
            next_bus_pos = buses[id_next].actual_map_pos
            new_speed = abs(next_bus_pos - buses[id].actual_map_pos)-1 
        elseif id_next != id
            next_bus_pos = buses[id_next].actual_map_pos + size(map.road)[2]
            new_speed = abs(next_bus_pos - buses[id].actual_map_pos) - 1 
            # println("checking exception busid = $(buses[id].id) and next_busID = $(buses[id_next].id) next_bus_pos: $(next_bus_pos)")
        end
        new_speed = new_speed > Constants.MAX_SPEED ? Constants.MAX_SPEED : new_speed
        buses[id].speed = new_speed
    end
end

function update(map::Map) # should update the road based on the speed of the 
    # show_info(map)
    # println(" ||| Moving |||\n")
    calculating_next_speed(map)
    move_bus!(map)
    show_info(map)
    # print("\n\n\n\n\n\n\n\n\n\n\n")
end

function main()
    map = initialize()
    while true
        run(`clear`)
        if length(map.buses) < 7
            add_bus(map)
        end
        update(map)
        sleep(1)
    end
    

end

end # module