function checking_possible_stop(map::Map, bus::Bus, new_speed::Int64)
    stations = map.stations
    road_size = size(map.road)[2]
    for station in stations
        if bus.route[station.id] == 1
            future_pos = new_speed + bus.actual_map_pos
            if future_pos >= station.init_pos && (future_pos - new_speed) <= station.init_pos
                new_speed -= (future_pos-station.init_pos)
                return true, new_speed, station.id
            end
         end
    end
    return false
end

function calculating_next_speed!(map::Map)
    buses = map.buses
    # sort!(buses)
    road_size = size(map.road)[2]
    id_next = -1
    for id in 1:length(buses)
        if buses[id].flag == Constants.LEAVING
            buses[id].speed = 0
        end
        if buses[id].flag == Constants.DRIVING
            actual_pos = buses[id].actual_map_pos
            new_speed = 0
            while new_speed < Constants.MAX_SPEED
                if actual_pos + new_speed+1 > size(map.road)[2]
                    new_speed = Constants.MAX_SPEED
                    break
                elseif map.road[1, actual_pos + new_speed+1] != Constants.BUS
                    new_speed += 1
                else
                    break
                end
                # print("new speed $(new_speed)\n")
            end
            tuple = checking_possible_stop(map, buses[id], new_speed)
            if tuple[1] == true
                new_speed = tuple[2]
                buses[id].stop_at = tuple[3]
            end
            # checking if will pass over a station
            buses[id].speed = new_speed
        end
        if id_next != -1 && id_next <= length(buses)
            @assert ((buses[id].actual_map_pos + new_speed) > buses[id_next].actual_map_pos) "Calculating speed wrongly! BUS ID: $(buses[id].id) | NEXT_POS (Estimated): $(buses[id].speed + buses[id].actual_map_pos) || Next POS ID: $(map.road[1, buses[id].speed + buses[id].actual_map_pos]) "
        end
    end
end

function calculating_next_speed_parallel!(map::Map)
    buses = map.buses
    # sort!(buses)
    road_size = size(map.road)[2]
    id_next = -1
    Threads.@threads for id in 1:length(buses)
        if buses[id].flag == Constants.LEAVING
            buses[id].speed = 0
        end
        if buses[id].flag == Constants.DRIVING
            actual_pos = buses[id].actual_map_pos
            new_speed = 0
            while new_speed < Constants.MAX_SPEED
                if actual_pos + new_speed+1 > size(map.road)[2]
                    new_speed = Constants.MAX_SPEED
                    break
                elseif map.road[1, actual_pos + new_speed+1] != Constants.BUS
                    new_speed += 1
                else
                    break
                end
                # print("new speed $(new_speed)\n")
            end
            tuple = checking_possible_stop(map, buses[id], new_speed)
            if tuple[1] == true
                new_speed = tuple[2]
                buses[id].stop_at = tuple[3]
            end
            # checking if will pass over a station
            buses[id].speed = new_speed
        end
        if id_next != -1 && id_next <= length(buses)
            @assert ((buses[id].actual_map_pos + new_speed) > buses[id_next].actual_map_pos) "Calculating speed wrongly! BUS ID: $(buses[id].id) | NEXT_POS (Estimated): $(buses[id].speed + buses[id].actual_map_pos) || Next POS ID: $(map.road[1, buses[id].speed + buses[id].actual_map_pos]) "
        end
    end
end

function calculating_next_speed_parallel_v2!(map::Map)
    buses = map.buses
    # sort!(buses)
    road_size = size(map.road)[2]
    id_next = -1
    Threads.@threads for id in 1:length(buses)
        if buses[id].flag == Constants.LEAVING
            buses[id].speed = 0
        end
        if buses[id].flag == Constants.DRIVING
            actual_pos = buses[id].actual_map_pos
            new_speed = 0
            while new_speed < Constants.MAX_SPEED
                if actual_pos + new_speed+1 > size(map.road)[2]
                    new_speed = Constants.MAX_SPEED
                    break
                elseif map.road[1, actual_pos + new_speed+1] != Constants.BUS
                    new_speed += 1
                else
                    break
                end
                # print("new speed $(new_speed)\n")
            end
            tuple = checking_possible_stop(map, buses[id], new_speed)
            if tuple[1] == true
                new_speed = tuple[2]
                buses[id].stop_at = tuple[3]
            end
            # checking if will pass over a station
            buses[id].speed = new_speed
        end
        if id_next != -1 && id_next <= length(buses)
            @assert ((buses[id].actual_map_pos + new_speed) > buses[id_next].actual_map_pos) "Calculating speed wrongly! BUS ID: $(buses[id].id) | NEXT_POS (Estimated): $(buses[id].speed + buses[id].actual_map_pos) || Next POS ID: $(map.road[1, buses[id].speed + buses[id].actual_map_pos]) "
        end
    end
end
