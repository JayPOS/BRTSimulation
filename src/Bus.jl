import Base: isless
using Random


module Constants

MAX_SPEED = 5
MAX_STATION_LENGTH = 2
MAX_ROUTES = 3

EMPTY = 0
BUS = 1
STATION = 2

DRIVING = 1
STOPPED = 2
LEAVING = 3

COOLDOWN = 3
MAX_SLOTS = 3

end # module

abstract type Cell end
abstract type AbstractStation <: Cell end

struct EmptyCell <: Cell end

mutable struct Bus <: Cell
    id::Int64
    speed::Int64 # Speed in actual iteration
    flag::Int8
    actual_map_pos::Int64
    route::Vector{Int8}
    stop_at::Int64 
end

create_bus(id::Int64) =  Bus(id, 0, Constants.DRIVING, 1, Vector{Int8}(undef,0), -1)

function reset!(b::Bus)
    b.speed = 0
    b.flag = Constants.DRIVING
    b.actual_map_pos = 1
    b.stop_at = -1
    reverse!(b.route)
end

create_bus_slot(bus::Bus) = [Constants.COOLDOWN, bus]

isless(a::Bus, b::Bus) = isless(a.actual_map_pos, b.actual_map_pos) # auxiliar function to sorting Bus vector

function next_index(i::Int64, size::Int64)
    if i+1 > size
        return 1
    end
    return i+1
end