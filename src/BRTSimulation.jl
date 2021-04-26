module BRTSimulation

include("./Map.jl")

function add_bus(map::Map, bus_queue::Vector{Bus}, route_mode::String) # add always in the beginning
    if map.road[1,1] == Constants.EMPTY && length(bus_queue) > 0
        new_bus = popat!(bus_queue, 1)
        if length(new_bus.route) == 0
            define_route(new_bus, map)
        end
        map.road[1,1] = 1
        push!(map.buses, new_bus)
        # println("Recente added bus with id $(new_bus.id)")
    else
        # println("Invalid Operation! First Position of road is occupied")
    end
end

function checking_possible_stop(map::Map, bus::Bus, new_speed::Int64)
    # println("Checking Possible Stop:")
    # show_info(map)
    # println("Finished Checking")
    # print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
    stations = map.stations
    road_size = size(map.road)[2]
    for station in stations
        if bus.route[station.id] == 1
            future_pos = new_speed + bus.actual_map_pos
            # if future_pos >  road_size
            #     # HAS TO USE PORTAL
            #     future_pos -= road_size
            # end
            # IF COLOSION == YES
            if future_pos >= station.init_pos && (future_pos - new_speed) <= station.init_pos
                new_speed -= (future_pos-station.init_pos)
                # println("Colision Happened! BusID: $(bus.id) || Station hitted: $(station.id) ---> Located in: $(station.init_pos):$(station.ending_pos) ||
                # New Speed Should be: $(new_speed) || Last Position: $(bus.actual_map_pos)")
                return true, new_speed, station.id
            end
         end
    end
    return false
end

function move_bus!(map::Map, ending_bus_queue::Vector{Bus})
    road_size = size(map.road)[2]

    copy_road = copy(map.road)
    buses = map.buses

    for id in 1:length(buses)
        if id > length(buses) 
            break 
        end
        if buses[id].flag == Constants.DRIVING
            next_pos = buses[id].actual_map_pos + buses[id].speed
            # println(" HERE Pos: $(buses[id].actual_map_pos) Speed: $(buses[id].speed) BUSID: $(buses[id].id)")
            if next_pos > road_size # REMOVING BUS FROM ROAD AND ADDING IN ENDING_BUS_QUEUE
                map.road[1, buses[id].actual_map_pos] = 0
                reset!(buses[id])
                push!(ending_bus_queue, popat!(map.buses, id))

                continue

                # println(" HERE NextPOS: $(next_pos)  roadSize: $(road_size)")
            end
            # CHECKING IF IT IS TIME TO STOP
            if buses[id].stop_at != -1 && map.stations[buses[id].stop_at].init_pos == buses[id].actual_map_pos
                # CHECKING IF STATION HAS ANY FREE SLOTS
                if length(map.stations[buses[id].stop_at].bus_slots) < Constants.MAX_SLOTS
                    push!(map.stations[buses[id].stop_at].bus_slots, create_bus_slot(buses[id]))
                    buses[id].stop_at = -1
                    map.road[1,buses[id].actual_map_pos] = 0
                    buses[id].flag = Constants.STOPPED
                end
            # IF IT IS NOT TIME TO STOP, THEN MOVE IF POSSIBLE, AND IF BUS IS NOT STOPPED
            elseif copy_road[1,next_pos] == Constants.EMPTY && buses[id].flag == Constants.DRIVING
                map.road[1, next_pos] = Constants.BUS
                map.road[1, buses[id].actual_map_pos] = Constants.EMPTY
                buses[id].actual_map_pos = next_pos
            else
                # print_buses(map.buses)
                # print_buses(buses)
                @assert next_pos == buses[id].actual_map_pos "Target Position ($(next_pos)) not empty! || Bus_ID: $(buses[id].id) || Target is a $(copy_road[1,next_pos] == 1 ? "Bus" : "Station")"
                # IF IT PRINTS THIS, IT MEANS SOMETHING WENT WRONG IN THE ALGORITHM (BUS IS TRYING TO MOVE TO AN OCCUPIED CELL)
                # println("Target Position not empty! || Bus_ID: $(buses[id].id)")
            end
        end
    end
end


function calculating_next_speed(map::Map)
    buses = map.buses
    sort!(buses)
    road_size = size(map.road)[2]
    new_speed = Constants.MAX_SPEED
    for id in 1:length(buses)
        if buses[id].flag == Constants.LEAVING
            buses[id].speed = 0
            # if buses[id].id == 2
            #     println("passei aqui buses[id].flag == Constants.LEAVING")
            # end
        end
        if buses[id].flag == Constants.DRIVING
            if id != length(buses)
                id_next = get_next_busId(buses, id+1)
                # if buses[id].id == 2
                #     println("passei aqui id != length(buses)")
                #     println(buses[id])
                #     println(buses[id+1])
                # end
                if id_next <= length(buses)
                    next_bus_pos = buses[id_next].actual_map_pos
                    new_speed = abs(next_bus_pos - buses[id].actual_map_pos)-1 
                    new_speed = new_speed > Constants.MAX_SPEED ? Constants.MAX_SPEED : new_speed
                    # if buses[id].id == 2
                    #     println("passei aqui id_next <= length(buses)")
                    # end
                end
            else
                new_speed=Constants.MAX_SPEED
                # if buses[id].id == 2
                #     println("passei aqui id_next > length(buses)")
                # end
            end
            tuple = checking_possible_stop(map, buses[id], new_speed)
            if tuple[1] == true
                new_speed = tuple[2]
                buses[id].stop_at = tuple[3]
                # if buses[id].id == 2
                #     println("passei aqui tuple = checking_possible_stop(map, buses[id], new_speed) / tuple[1] == true")
                # end
            end
            # checking if will pass over a station
            buses[id].speed = new_speed
        end
    end
end

function calculating_next_speed_parallel(map::Map)
    buses = map.buses
    sort!(buses)
    road_size = size(map.road)[2]
    new_speed = Constants.MAX_SPEED
    Threads.@threads for id in 1:length(buses)
        if buses[id].flag == Constants.LEAVING
            buses[id].speed = 0
            # if buses[id].id == 2
            #     println("passei aqui buses[id].flag == Constants.LEAVING")
            # end
        end
        if buses[id].flag == Constants.DRIVING
            if id != length(buses)
                id_next = get_next_busId(buses, id+1)
                # if buses[id].id == 2
                #     println("passei aqui id != length(buses)")
                #     println(buses[id])
                #     println(buses[id+1])
                # end
                if id_next <= length(buses)
                    next_bus_pos = buses[id_next].actual_map_pos
                    new_speed = abs(next_bus_pos - buses[id].actual_map_pos)-1 
                    new_speed = new_speed > Constants.MAX_SPEED ? Constants.MAX_SPEED : new_speed
                    # if buses[id].id == 2
                    #     println("passei aqui id_next <= length(buses)")
                    # end
                end
            else
                new_speed=Constants.MAX_SPEED
                # if buses[id].id == 2
                #     println("passei aqui id_next > length(buses)")
                # end
            end
            tuple = checking_possible_stop(map, buses[id], new_speed)
            if tuple[1] == true
                new_speed = tuple[2]
                buses[id].stop_at = tuple[3]
                # if buses[id].id == 2
                #     println("passei aqui tuple = checking_possible_stop(map, buses[id], new_speed) / tuple[1] == true")
                # end
            end
            # checking if will pass over a station
            buses[id].speed = new_speed
        end
    end
end

function iteraction(map::Map,
            initial_bus_queue::Vector{Bus}, 
            ending_bus_queue::Vector{Bus},
            route_mode::String
    ) 
    # show_info(map)
    # println("\n ---->  ||| Moving |||  <----\n")
    add_bus(map, initial_bus_queue, route_mode)
    update_station(map)
    calculating_next_speed(map)
    move_bus!(map, ending_bus_queue)
    # show_info(map)
    # print("\n\n\n")
end

function iteraction_parallel(map::Map,
    initial_bus_queue::Vector{Bus}, 
    ending_bus_queue::Vector{Bus},
    route_mode::String
) 
# show_info(map)
# println("\n ---->  ||| Moving |||  <----\n")
add_bus(map, initial_bus_queue, route_mode)
update_station(map)
calculating_next_speed_parallel(map)
move_bus!(map, ending_bus_queue)
# show_info(map)
# print("\n\n\n")
end

function run_Parallel(map::Map;num_iteration::Int64=100000, buses::Int64=7, route_mode::String="RANDOM")
    @assert buses < size(map.road)[2] "Number of buses should be less than length of road"
    counter = 0
    initial_bus_queue = init_bus_queue(buses)
    reverted_map = init_reverse(map)
    ending_bus_queue = init_bus_queue(buses)
    for counter in 1:num_iteration
        # run(`clear`)
        # println("Map:: \n")
        iteraction_parallel(map, initial_bus_queue, initial_bus_queue, route_mode)
        # print("\n\n")
        # println("Reverted Map:: \n")
        # iteraction_parallel(reverted_map, ending_bus_queue, ending_bus_queue, route_mode)
        # print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
        # sleep(1)
    end
    # return reverted_map, initial_bus_queue, ending_bus_queue
end

function run_Simulation(map::Map;num_iteration::Int64=100000, buses::Int64=7, route_mode::String="RANDOM")
    @assert buses < size(map.road)[2] "Number of buses should be less than length of road"
    counter = 0
    initial_bus_queue = init_bus_queue(buses)
    reverted_map = init_reverse(map)
    ending_bus_queue = init_bus_queue(buses)
    for counter in 1:num_iteration
        # run(`clear`)
        # println("Map:: \n")
        iteraction(map, initial_bus_queue, initial_bus_queue, route_mode)
        # print("\n\n")
        # println("Reverted Map:: \n")
        # iteraction(reverted_map, ending_bus_queue, ending_bus_queue, route_mode)
        # print("-----------------------------------------------END---------------------------------------------------------\n")
        # sleep(1)
    end
    # return reverted_map, initial_bus_queue, ending_bus_queue
end

end # module