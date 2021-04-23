include("./Bus.jl") # Has everything of buses

mutable struct Map
    road::Matrix{Int8}
    stations::Vector{Station}
    buses::Vector{Bus}
    routes::Matrix{Int8}
    id_counter::Int64
end

init_map() = Map(
    zeros(30,2), 
    Vector{Station}(undef, 0), 
    Vector{Bus}(undef, 0),
    Matrix{Int8}(undef, 0,0),
    1
)

function initialize()
    map = init_map()
    map.road = transpose(map.road)
    add_stations(map)
    create_routes(map)
    return map
end

# STATION SECTION
# list of functions: create_routes, define_route, add_station.

function add_stations(map::Map)
    println("Type the number of stations:")
    input = readline()
    n_stations = -1
    try n_stations = parse(Int64, input)
    catch e
        println("Invalid Input! Number of stations can only be Integers!")
        return false
    end
    if n_stations > size(map.road)[2]
        println("Invalid Input! Number of stations cant be more than spaces in Road!")
        return false
    end
    for i in 1:n_stations
        println("Type the initial position for Station $(i):")
        input = readline()
        init_pos = -1
        try init_pos = parse(Int64, input)
        catch e
            println("Invalid Input! Initial Position can only be Integers!")
            return false
        end
        if init_pos > size(map.road)[2] || init_pos < 0
            println("Invalid Input! Stations initial position has to be between the beginning and the end of the Road!")
            return false
        end
        push!(map.stations, create_station(i, init_pos))
    end
    return true
end

function create_routes(map::Map)
    n_stations = length(map.stations)
    map.routes = Matrix{Int8}(undef, n_stations, 0)
    map.routes = transpose(map.routes)
    for i in 1:Constants.MAX_ROUTES
        map.routes = [map.routes; rand([0,1], 1,n_stations)]
    end
end

function define_route(bus::Bus, map::Map)
    n_stations = length(map.stations)
    random_line = rand(1:Constants.MAX_ROUTES)
    for i in 1:n_stations
        push!(bus.route, map.routes[random_line, i])
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
    for bus in buses
        println("Bus ID: $(bus.id) || Speed: $(bus.speed) || State: $(bus.flag) || Map Position: $(bus.actual_map_pos) || Routes: $(bus.route)")
    end
end

function show_info(map::Map)
    print_map(map)
    println("\n")
    print_buses(map.buses)
end