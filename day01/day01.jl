using CSV

function go(filename::String)
    data = CSV.Tables.matrix(CSV.File(filename, delim=" ", header=false, ignorerepeated=true))
    println("Filename = $(filename)")
    data[:,1] = sort(data[:,1]) # sort! doesn't work for slices?   
    data[:,2] = sort(data[:,2])

    # part 1
    println("Total distance = $(sum(abs.(data[:,1] - data[:,2])))")

    # part 2
    score = 0
    for n in data[:,1]
        score += sum(data[:,2] .== n)*n
    end
    println("Similarity score = $(score)")
end

go("day01/test.txt")
go("day01/input.txt")