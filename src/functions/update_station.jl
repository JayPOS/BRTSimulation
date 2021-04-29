function can_leave_station(map::Map, station::Station)
    if map.road[1, station.ending_pos] == Constants.EMPTY
        return true
    end
    return false
end

function departing_bus(station::Station, bus::Bus, road::Matrix{Int8})
    for i in 1:length(station.bus_slots)
        if i > length(station.bus_slots)
            break
        end
        if station.bus_slots[i][2].id == bus.id
            bus.actual_map_pos = station.ending_pos
            bus.flag = Constants.LEAVING
            if road[1, bus.actual_map_pos] == Constants.EMPTY
                bus.flag = Constants.DRIVING
                road[1, bus.actual_map_pos] = Constants.BUS
                deleteat!(station.bus_slots, i)
            end
        end
    end
    
end


function update_station(map::Map)
    stations = map.stations
    for station in stations
        departing_buses = []
        for slot in station.bus_slots
            # println("SLOTS $(length(station.bus_slots)) ID: $(station.id)")
            slot[1] -= 1 # Updating Cooldown
            if slot[1] <= 0 # Cooldown is over?
                if can_leave_station(map, station)
                    push!(departing_buses, slot[2]) #
                end
            end
        end
        for i in 1:length(departing_buses)
            # println("$(i)) $(length(departing_buses))")
            departing_bus(station, departing_buses[i], map.road)
        end
    end
end