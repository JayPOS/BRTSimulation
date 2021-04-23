using DataStructures
import Base: isless
using Random


module Constants

MAX_SPEED = 5
MAX_STATION_LENGTH = 3
MAX_ROUTES = 3

EMPTY = 0
BUS = 1
STATION = 2

DRIVING = 1
STOPPED = 2

COOLDOWN = 3

end # module

abstract type Cell end

struct EmptyCell <: Cell end

mutable struct Bus <: Cell
    id::Int64
    speed::Int64 # Speed in actual iteration
    flag::Int16
    actual_map_pos::Int64
    route::Vector{Int8}
end

mutable struct Station <: Cell
    id::Int64
    init_pos::Int64
    ending_pos::Int64
    bus_slots::Vector{Pair{Int64, Bus}}
end

create_bus(id::Int64) =  Bus(id, 0, Constants.DRIVING, 1, Vector{Int8}(undef,0))

create_station(id::Int64, init_pos::Int64) = Station(id, init_pos, init_pos+Constants.MAX_STATION_LENGTH, Vector{Pair{Int64, Bus}}(undef, 0))

create_station_pair(bus::Bus) = Pair{Int64, Bus}(Constants.COOLDOWN, bus)

isless(a::Bus, b::Bus) = isless(a.actual_map_pos, b.actual_map_pos) # auxiliar function to sorting Bus vector

function next_index(i::Int64, size::Int64)
    if i+1 > size
        return 1
    end
    return i+1
end