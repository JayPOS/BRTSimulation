
function run_Parallel_v1(map::Map;num_iteration::Int64=100000, buses::Int64=7, route_mode::String="RANDOM")
    @assert buses < size(map.road)[2] "Number of buses should be less than length of road"
    counter = 0
    initial_bus_queue = init_bus_queue(buses)
    reverted_map = init_reverse(map)
    ending_bus_queue = init_bus_queue(buses)
    for counter in 1:num_iteration
        # run(`clear`)
        # println("Map:: \n")
        iteraction_parallel_v1(map, initial_bus_queue, initial_bus_queue, route_mode)
        # print("\n\n")
        # println("Reverted Map:: \n")
        # iteraction_parallel(reverted_map, ending_bus_queue, ending_bus_queue, route_mode)
        # print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
        # sleep(1)
    end
    # return reverted_map, initial_bus_queue, ending_bus_queue
end

function run_Parallel_v2(map::Map;num_iteration::Int64=100000, buses::Int64=7, route_mode::String="RANDOM")
    @assert buses < size(map.road)[2] "Number of buses should be less than length of road"
    counter = 0
    initial_bus_queue = init_bus_queue(buses)
    reverted_map = init_reverse(map)
    ending_bus_queue = init_bus_queue(buses)
    for counter in 1:num_iteration
        # run(`clear`)
        # println("Map:: \n")
        iteraction_parallel_v2(map, initial_bus_queue, initial_bus_queue, route_mode)
        # print("\n\n")
        # println("Reverted Map:: \n")
        # iteraction_parallel(reverted_map, ending_bus_queue, ending_bus_queue, route_mode)
        # print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
        # sleep(1)
    end
    # return reverted_map, initial_bus_queue, ending_bus_queue
end

function run_Simulation(map::Map;num_iteration::Int64=100000, buses::Int64=7, route_mode::String="RANDOM")
    @assert buses < size(map.road)[2] "Number of buses should be less than length of road"
    counter = 0
    initial_bus_queue = init_bus_queue(buses)
    reverted_map = init_reverse(map)
    ending_bus_queue = init_bus_queue(buses)
    for counter in 1:num_iteration
        # run(`clear`)
        # println("Map:: \n")
        iteraction(map, initial_bus_queue, initial_bus_queue, route_mode)
        # print("\n\n")
        # println("Reverted Map:: \n")
        # iteraction(reverted_map, ending_bus_queue, ending_bus_queue, route_mode)
        # print("-----------------------------------------------END---------------------------------------------------------\n")
        # sleep(1)
    end
    # return reverted_map, initial_bus_queue, ending_bus_queue
end