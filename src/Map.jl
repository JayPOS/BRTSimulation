include("./Bus.jl") # Has everything of buses

mutable struct Map{T<:Cell}
    road::Matrix{T}
    stations::Vector{Station}
    buses::Vector{Bus}
    id_counter::Int64
end

global ID_COUNTER = 1 # COUNTER

init_map() = Map(
    Matrix{Cell}(undef, 2, 30), 
    Vector{Station}(undef, 0), 
    Vector{Bus}(undef, 0),
    1
)

function init_empty_road(map::Map)
    dims = size(map.road)
    for i in 1:dims[1]
        for j in 1:dims[2]
            map.road[i,j] = EmptyCell()
        end
    end
end

function initialize()
    map = init_map()
    init_empty_road(map)
    return map
end

function add_bus(map::Map) # add always in the beginning
    if map.road[1,1] isa EmptyCell
        new_bus = create_bus(map.id_counter, 2)
        map.id_counter += 1
        map.road[1,1] = new_bus
        push!(map.buses, new_bus)
    else
        println("Invalid Operation! First Position of road is occupied")
    end
end

function print_map(map::Map)
    for row in eachrow(map.road)
        for cell in row
            if is_empty(cell)
                print("0 ")
            elseif is_bus(cell)
                print("1 ")
            elseif is_station(cell)
                print("2 ")
            end
        end
        println()
    end
end