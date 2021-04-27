include("./Bus.jl") # Has everything of buses

mutable struct Map
    road::Matrix{Int8}
    stations::Vector{Station}
    buses::Vector{Bus}
    routes::Matrix{Int8}
    route_mode::String
end

init_map(road_size::Int64, route_mode::String) = Map(
    zeros(road_size,2), 
    Vector{Station}(undef, 0), 
    Vector{Bus}(undef, 0),
    Matrix{Int8}(undef, 0,0),
    route_mode
)

# TAKE OUT ADD_STATIONS(MAP) AND USE PARAMETERS
function init(;road_size::Int64, stations::Vector{Int64}=[2,10], station_size::Int64=3, route_mode::String="NORMAL")
    # TREATING INPUTS
    @assert length(stations)*station_size < road_size "No enough space in road for this number of stations"
    sort!(stations)
    for i in 1:length(stations)-1
        @assert abs(stations[i]-stations[i+1]) >= station_size "No enough space between Station at positions $(stations[i]) and $(stations[i+1])"
    end

    map = init_map(road_size, route_mode)
    map.road = transpose(map.road)
    add_stations(map, length(stations), stations, station_size)
    create_routes(map)
    return map
end

function init_reverse(map::Map)
    station_length = map.stations[1].ending_pos - map.stations[1].init_pos
    road_length = size(map.road)[2]
    reverted_stations = Vector{Int64}(undef, 0)

    reverse_station(ending_station_pos::Int64, road_size::Int64) = road_size - ending_station_pos + 1

    for station in map.stations
        push!(reverted_stations, reverse_station(station.ending_pos, road_length))
    end
    reverted_map = init(road_size=road_length, stations=reverted_stations, station_size=station_length, route_mode=map.route_mode)
    return reverted_map
end

function init_bus_queue(n_buses::Int64)
    bus_queue = Vector{Bus}(undef, 0)
    for i in 1:n_buses
        push!(bus_queue, create_bus(i))
    end
    return bus_queue
end

function get_bus(buses::Vector{Bus}, id::Int64)
    for bus in buses
        if bus.id == id
            return bus
        end
    end
    return -1 
end

# STATION SECTION
# list of functions: create_routes, define_route, add_station.

function add_stations(map::Map, n_stations::Int64, init_positions::Vector{Int64}, station_length::Int64) # TAKE OUT INPUTS
    # MUDAR TRY CATCH PARA @assert [condition] "string"
    for i in 1:n_stations
        new_station = create_station(i, init_positions[i], station_length)
        push!(map.stations, new_station)
        for i in new_station.init_pos:new_station.ending_pos
            map.road[2, i] = Constants.STATION
        end
    end
    return true
end

function create_routes(map::Map)
    n_stations = length(map.stations)
    map.routes = Matrix{Int8}(undef, n_stations, 0)
    map.routes = transpose(map.routes)
    if map.route_mode == "NORMAL"
        map.routes = [map.routes; zeros(Int8, 1,n_stations)]
        map.routes = [map.routes; ones(Int8, 1,n_stations)]
    elseif map.route_mode == "RANDOM"
        for i in 1:Constants.MAX_ROUTES
            push!(map.routes, rand([0,1], 1,n_stations))
        end
    end
end

function define_route(bus::Bus, map::Map)
    n_stations = length(map.stations)
    if map.route_mode == "NORMAL"
        if bus.id % 2 == 0
            for i in 1:n_stations
                push!(bus.route, map.routes[1, i])
            end
        else
            for i in 1:n_stations
                push!(bus.route, map.routes[2, i])
            end
        end
    elseif map.route_mode == "RANDOM"
        random_line = rand(1:Constants.MAX_ROUTES)
        for i in 1:n_stations
            push!(bus.route, map.routes[random_line, i])
        end
    end
end

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

# PRINTING SECTION

function print_map(map::Map)
    tam = size(map.road)
    for i in 1:tam[1]
        for j in 1:tam[2]
            print("$(map.road[i,j]) ")
        end
        println()
    end
end

function print_buses(buses::Vector{Bus})
    copy = sort(buses)
    for bus in copy
        println("Bus ID: $(bus.id) || Speed: $(bus.speed) || State: $(bus.flag) || Map Position: $(bus.actual_map_pos) || Routes: $(bus.route[1])")
    end
end

function print_bus_slots(bus_slots::Vector{Vector{Any}})
    aux_string = ""
    for bus_slot in bus_slots
        string(aux_string, "", "\n        || Bus ID: $(bus_slot[2]) || Remaining Cooldown: $(bus_slot[1])")
    end
    return aux_string
end

function print_station(stations::Vector{Station})
    for station in stations
        if length(station.bus_slots) > 0
            println("Station ID: $(station.id) || Station Location: $(station.init_pos)-$(station.ending_pos) || Bus_Slots:")
            for i in 1:length(station.bus_slots)
                println("         ---> || Bus_Slot $(i) || Bus ID: $(station.bus_slots[i][2].id) || Remaining Cooldown: $(station.bus_slots[i][1])")
            end
        end
    end
end

function show_info(map::Map)
    # print_map(map)
    println("\n")
    print_buses(map.buses)
    println("\n")
    print_station(map.stations)
end

# AUXILIAR FUNCTIONS STARTS HERE

function get_next_busId(buses::Vector{Bus}, id_next::Int64)
    while id_next <= length(buses) && (buses[id_next].flag != Constants.DRIVING || buses[id_next].flag != Constants.LEAVING)
        id_next+=1
        # print("id_next: $(id_next) length(buses): $(length(buses)) || buses[id_next].flag: $(buses[id_next].flag)\n")
    end
    # println("saiu haha")
    return id_next
end