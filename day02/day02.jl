function go(filename)
    lines = readlines(filename)
    n_safe = 0
    n_safe_p2 = 0

    is_safe(d) = all((d .<= -1) .& (d.>= -3)) | all((d .>= 1) .& (d.<= 3))

    for line in lines
        levels = parse.(Int32, split(line, " "))
        d = diff(levels)
        if (is_safe(d))
            n_safe += 1
        end

        for m in 1:length(levels)
            d = diff([levels[1:(m-1)]; levels[m+1:end]])
            if is_safe(d)
                n_safe_p2 += 1
                break
            end
        end
    end
    println("Filename = $(filename)")
    println("Safe records = $(n_safe)")
    println("Safe records with dampener = $(n_safe_p2)")
end

# input is small enough that for part 2 we can just do an exhaustive search
# no doubt there is a much smart way of doing this

go("day02/test.txt")
go("day02/input.txt")