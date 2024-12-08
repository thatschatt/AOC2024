
function go(filename)
    display(filename)
    lines = readlines(filename)
    antmap = reduce(vcat, permutedims.(collect.(lines)))
    antennas = unique(antmap[antmap .!= '.'])
    antinodes = Set()
    @show bounds_x = (1, size(antmap, 2))
    @show bounds_y = (1, size(antmap, 1))

    for ant in antennas
        coords = findall(antmap .== ant)
        for n in 1:(length(coords)-1)
            for m in (n+1):length(coords)
                in_phase = 2*coords[n] - coords[m]
                if (in_phase[1] >= bounds_x[1]) && (in_phase[1] <= bounds_x[2]) && 
                    (in_phase[2] >= bounds_y[1]) && (in_phase[2] <= bounds_y[2])
                    push!(antinodes, in_phase)
                end
                out_phase = 2*coords[m] - coords[n]
                if (out_phase[1] >= bounds_x[1]) && (out_phase[1] <= bounds_x[2]) && 
                    (out_phase[2] >= bounds_y[1]) && (out_phase[2] <= bounds_y[2])
                    push!(antinodes, out_phase)
                end
            end
        end
    end
    display(antinodes)
    return length(antinodes)
end

function go2(filename)
    display(filename)
    lines = readlines(filename)
    antmap = reduce(vcat, permutedims.(collect.(lines)))
    antennas = unique(antmap[antmap .!= '.'])
    antinodes = Set()
    @show bounds_x = (1, size(antmap, 2))
    @show bounds_y = (1, size(antmap, 1))

    for ant in antennas
        coords = findall(antmap .== ant)
        for n in 1:(length(coords)-1)
            for m in (n+1):length(coords)
                # first do the in phase combos
                for i in 0:100 
                    in_phase = coords[n] + i*(coords[m] - coords[n])
                    if (in_phase[1] >= bounds_x[1]) && (in_phase[1] <= bounds_x[2]) && 
                        (in_phase[2] >= bounds_y[1]) && (in_phase[2] <= bounds_y[2])
                        push!(antinodes, in_phase)
                    else
                        break
                    end
                end

                # repeat for out of phase (yes this could obviously be a function)
                for i in 0:100 
                    out_phase = coords[n] - i*(coords[m] - coords[n])
                    if (out_phase[1] >= bounds_x[1]) && (out_phase[1] <= bounds_x[2]) && 
                        (out_phase[2] >= bounds_y[1]) && (out_phase[2] <= bounds_y[2])
                        push!(antinodes, out_phase)
                    else
                        break
                    end
                end
            end
        end
    end
    display(antinodes)
    return length(antinodes)
end

## part 2, I guess I just change the in_phase / out_phase logic into a pair of loops
## that go until we exit the bounds. Remeber to also add the antenna positions to the
## antinode set.


display(go("day08/test.txt"))
display(go("day08/input.txt"))

display(go2("day08/test.txt"))
display(go2("day08/input.txt"))
