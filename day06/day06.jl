const up = CartesianIndex(-1, 0)
const right = CartesianIndex(0, 1)
const down = CartesianIndex(1, 0)
const left = CartesianIndex(0, -1)

const turn_dir = Dict(up => right, right => down, down => left, left => up)
const dir_bits = Dict(up => 8, right => 4, down => 2, left => 1)

function go(filename)
    lines = readlines(filename)
    guardmap = reduce(vcat, permutedims.(collect.(lines)))
    guard_pos = findall(guardmap .== '^')[1]
    direction = up
    
    while (true)
        guardmap[guard_pos] = 'X'
        try
            next_tile = guardmap[guard_pos + direction]
            if next_tile == '#'
                direction = turn_dir[direction]
            else
                guard_pos += direction
            end
        catch
            break
        end
    end

    display(guardmap)
    println("Total X = $(sum(guardmap .== 'X'))")
end

function detect_loop(guardmap)
    guard_poses = findall(guardmap .== '^')
    if length(guard_poses) == 0
        return 0 # looks like we overwrote the start, which is banned
    end
    guard_pos = guard_poses[1]
    direction = up
    
    for n in (1:100_000)
        # this time we marke each position with the direction the guard was going in
        if guardmap[guard_pos] >= 'a' && guardmap[guard_pos] <= 'q'
            if ((guardmap[guard_pos] - 'a') & dir_bits[direction]) != 0 # non zero != true in julia
                return 1
            else
                guardmap[guard_pos] = ((guardmap[guard_pos] - 'a') | dir_bits[direction]) + 'a'
            end
        else
            guardmap[guard_pos] = dir_bits[direction] + 'a'
        end
        try
            next_tile = guardmap[guard_pos + direction]
            if next_tile == '#'
                direction = turn_dir[direction]
            else
                guard_pos += direction
            end
        catch
            return 0
        end
    end
    println("Timeout!")
end

function go2(filename)
    lines = readlines(filename)
    guardmap = reduce(vcat, permutedims.(collect.(lines)))
    guard_pos = findall(guardmap .== '^')[1]
    direction = up
    loops = 0
    
    for pos in eachindex(guardmap)
        mod_map = copy(guardmap) # tons of allocation, whatever
        mod_map[pos] = '#'
        loops += detect_loop(mod_map)
    end
    return loops
end

# for part 2 I Replace the X's with a letter (a -> q) reperesnting 4 bits for each direction the
# guard could be going in. If they ever run over a point in the same direction, we have detected
#  a loop. 

#display(go("day06/test.txt"))
#display(go("day06/input.txt"))

display(go2("day06/test.txt"))
display(go2("day06/input.txt"))
