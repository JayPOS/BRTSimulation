function iteraction(map::Map,
    initial_bus_queue::Vector{Bus}, 
    ending_bus_queue::Vector{Bus},
    route_mode::String
) 
# show_info(map)
# println("\n ---->  ||| Moving |||  <----\n")
add_bus(map, initial_bus_queue, route_mode)
update_station(map)
calculating_next_speed!(map)
move_bus!(map, ending_bus_queue)
# show_info(map)
# print("\n\n\n")
end

function iteraction_parallel_v1(map::Map,
initial_bus_queue::Vector{Bus}, 
ending_bus_queue::Vector{Bus},
route_mode::String
) 
# show_info(map)
# println("\n ---->  ||| Moving |||  <----\n")
add_bus(map, initial_bus_queue, route_mode)
update_station(map)
calculating_next_speed_parallel!(map)
move_bus!(map, ending_bus_queue)
# show_info(map)
# print("\n\n\n")
end

function iteraction_parallel_v2(map::Map,
initial_bus_queue::Vector{Bus}, 
ending_bus_queue::Vector{Bus},
route_mode::String
) 
# show_info(map)
# println("\n ---->  ||| Moving |||  <----\n")
add_bus(map, initial_bus_queue, route_mode)
update_station(map)
calculating_next_speed_parallel!(map)
move_bus_parallel_v2!(map, ending_bus_queue)
# show_info(map)
# print("\n\n\n")
end