using Random

function teste()
    a = ones(10000)
    b = ones(10000)
    Threads.@threads for i in 1:length(a)
        a[i] += b[i]
    end
end