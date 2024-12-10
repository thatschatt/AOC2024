function check_trail(lavamap, position::CartesianIndex, last_value::Char)
    if (lavamap[position] != (last_value + 1) )
        return [] # end of the line
    end
    if (lavamap[position] == '9')
        return [position] # found an endpoint
    end
    trail_N = Nothing
    trail_E = Nothing
    trail_S = Nothing
    trail_W = Nothing
    outputs = []
    if position[1] > 1
        trail_N = check_trail(lavamap, position - CartesianIndex(1, 0,), lavamap[position])
        outputs = vcat(outputs, trail_N)
    end
    if position[2] > 1
        trail_E = check_trail(lavamap, position - CartesianIndex(0, 1,), lavamap[position])
        outputs = vcat(outputs, trail_E)
    end
    if position[1] < size(lavamap, 1)
        trail_S = check_trail(lavamap, position + CartesianIndex(1, 0,), lavamap[position])
        outputs = vcat(outputs, trail_S)
    end
    if position[2] < size(lavamap, 2)
        trail_W = check_trail(lavamap, position + CartesianIndex(0, 1,), lavamap[position])
        outputs = vcat(outputs, trail_W)
    end
    return outputs

end

function go(filename)
    display(filename)
    lines = readlines(filename)
    lavamap = reduce(vcat, permutedims.(collect.(lines)))
    start_points = findall(lavamap .== '0')
    score = 0
    score_2 = 0
    for s in start_points
        trails = check_trail(lavamap, s, '/')
        score += length(unique(trails))
        score_2 += length(trails)
    end
    return (score, score_2)
end

# for part 2 i guess I pass the route required to get to a position,
# and return a hash of the route for unique counting purposes
# actually , do I even need to do that? Can't I just remove the 'unique'
# qualifer?
# ------> yep.

display(go("day10/test.txt"))
display(go("day10/input.txt"))
