module Data

abstract type Cell end

struct EmptyCell <: Cell end

mutable struct Bus <: Cell
    bus_id::Int64
    bus_speed::Float64
    bus_flag::Int16
end

function create_bus(id::Int64, flag::Int64)
    bus = Bus_Data(id, 0, flag)
    return bus
end

function accelerate!(bus::Bus)
end

function deaccelerate!(bus::Bus)
end

function move!(bus::Bus, road)
end

end # module

# END OF Buses