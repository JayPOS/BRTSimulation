mutable struct Station
    id::Int64
    init_pos::Int64
    ending_pos::Int64
    bus_slots::Vector{Vector{Any}}
    bus_cooldown::Int8
end

create_station(id::Int64, init_pos::Int64, station_length::Int64) = Station(id, init_pos, init_pos + station_length, Vector{Vector{Any}}(undef, 0), station_length + Constants.COOLDOWN)