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
            if next_pos > road_size # REMOVING BUS FROM ROAD AND ADDING IN ENDING_BUS_QUEUE
                map.road[1, buses[id].actual_map_pos] = 0
                reset!(buses[id])
                push!(ending_bus_queue, popat!(map.buses, id))
                continue
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
                @assert next_pos == buses[id].actual_map_pos "Target Position ($(next_pos)) not empty! || Bus_ID: $(buses[id].id) || Target is a $(copy_road[1,next_pos] == 1 ? "Bus" : "Station")"
            end
        end
    end
end

function move_bus_parallel_v2!(map::Map, ending_bus_queue::Vector{Bus})
    road_size = size(map.road)[2]
    buses = map.buses

    Threads.@threads for i in 1:length(map.previous_road)
        map.previous_road[i] = map.road[1, i]
    end

    for id in 1:length(buses)
        if id > length(buses) 
            break 
        end
        if buses[id].flag == Constants.DRIVING
            next_pos = buses[id].actual_map_pos + buses[id].speed
            if next_pos > road_size # REMOVING BUS FROM ROAD AND ADDING IN ENDING_BUS_QUEUE
                map.road[1, buses[id].actual_map_pos] = 0
                reset!(buses[id])
                push!(ending_bus_queue, popat!(map.buses, id))
                continue
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
            elseif map.previous_road[next_pos] == Constants.EMPTY && buses[id].flag == Constants.DRIVING
                map.road[1, next_pos] = Constants.BUS
                map.road[1, buses[id].actual_map_pos] = Constants.EMPTY
                buses[id].actual_map_pos = next_pos
            else
                @assert next_pos == buses[id].actual_map_pos "Target Position ($(next_pos)) not empty! || Bus_ID: $(buses[id].id) || Target is a $(map.previous_road == 1 ? "Bus" : "Station")"
            end
        end
    end
end
