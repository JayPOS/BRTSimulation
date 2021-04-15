include("./components/Data.jl")

Bus = Data.Data.Bus

mutable struct Map
    buses::Vector{Bus}
    road::Matrix{}
end