using DataStructures
import Base: isless

abstract type Cell end

struct EmptyCell <: Cell end

mutable struct Bus <: Cell
    id::Int64
    speed::Int64 # Speed in actual iteration
    flag::Int16
    actual_map_pos::Int64
end

create_bus(id::Int64, flag::Int64) =  Bus(id, 0, flag, 1)

function accelerate!(bus::Bus)
end

function deaccelerate!(bus::Bus)
end

function move!(bus::Bus, road)
end

mutable struct Station <: Cell
    id::Int64
    init_pos::Int64
end

is_bus(item) = item isa Bus

is_station(item) = item isa Station

is_empty(item) = item isa EmptyCell

isless(a::Bus, b::Bus) = isless(a.actual_map_pos, b.actual_map_pos) # auxiliar function to sorting Bus vectors

# CONSTANTS SECTION BEGIN

module Constants

MAX_SPEED = 5

end # module

# END CONSTANTS SECTION

function next_index(i::Int64, size::Int64)
    if i+1 > size
        return 1
    end
    return i+1
end