const global directions = Dict(
    '>' => CartesianIndex(0, 1),
    '<' => CartesianIndex(0, -1),
    'v' => CartesianIndex(1, 0),
    '^' => CartesianIndex(-1, 0),
    )

function score_map(boxmap)
    boxes = findall(boxmap .== 'O')
    score = 0
    for b in boxes
        score += 100*(b[1]-1) + (b[2]-1)
    end
    return score
end

function push_object!(boxmap::Matrix{Char}, pos::CartesianIndex, direction::Char)
    o_type = boxmap[pos]
    if o_type == '#' # we hit a wall so nothing should move
        return false
    elseif o_type == '.' # moving into empty space is ok
        return true
    end
    if push_object!(boxmap, pos + directions[direction], direction)
        boxmap[pos] = '.' # this may get overridden by the next thing in the stack
        boxmap[pos + directions[direction]] = o_type
        return true # tell the next objet in the stack to move
    end
    return false # we must have hit a wall down the stack
end

function go(filename)
    display(filename)
    lines = readlines(filename * "_map.txt")
    boxmap = reduce(vcat, permutedims.(collect.(lines)))
    instr = readline(filename * "_instr.txt")
    display(boxmap)

    for d in instr
        p = findfirst(boxmap .== '@')
        push_object!(boxmap, p, d)
    end
    display(boxmap)
    println("score = $(score_map(boxmap))")
end

    ### part 2

function score_map2(boxmap)
    boxes = findall(boxmap .== '[')
    score = 0
    for b in boxes
        score += 100*(b[1]-1) + (b[2]-1)
    end
    return score
end    

function push_object2!(boxmap::Matrix{Char}, pos::CartesianIndex, direction::Char; pull=true)
    o_type = boxmap[pos]
    print(o_type)
    if o_type == '#' # we hit a wall so nothing should move
        return false
    elseif o_type == '.' # moving into empty space is ok
        return true
    end

    # if it's a box going up or down, also try and move the partner
    can_push = false
    if (o_type == '[') && (direction == '^' || direction == 'v') && pull # the pull param is to stop infinite loops of blocks trying to pull their neighbours
        can_push = push_object2!(boxmap, pos + directions[direction], direction) & push_object2!(boxmap, pos + directions['>'], direction; pull=false)
    elseif (o_type == ']') && (direction == '^' || direction == 'v') && pull
        can_push = push_object2!(boxmap, pos + directions[direction], direction) & push_object2!(boxmap, pos + directions['<'], direction; pull=false)
    else
        can_push = push_object2!(boxmap, pos + directions[direction], direction)
    end
    
    if can_push
        boxmap[pos] = '.' # this may get overridden by the next thing in the stack
        boxmap[pos + directions[direction]] = o_type
        return true # tell the next object in the stack to move
    end
    return false # we must have hit a wall down the stack
end


function go2(filename)
    display(filename)
    lines = readlines(filename * "_map.txt")
    boxmap = reduce(vcat, permutedims.(collect.(lines)))
    instr = readline(filename * "_instr.txt")
    boxmap2 = [boxmap boxmap] # jsut to get dimensions right
    for b in CartesianIndices(boxmap)
        if boxmap[b] == '#'
            boxmap2[b[1], (b[2]-1)*2+1] = '#'
            boxmap2[b[1], (b[2]-1)*2+2] = '#'
        elseif boxmap[b] == '.'
            boxmap2[b[1], (b[2]-1)*2+1] = '.'
            boxmap2[b[1], (b[2]-1)*2+2] = '.'
        elseif boxmap[b] == '@'
            boxmap2[b[1], (b[2]-1)*2+1] = '@'
            boxmap2[b[1], (b[2]-1)*2+2] = '.'
        elseif boxmap[b] == 'O'
            boxmap2[b[1], (b[2]-1)*2+1] = '['
            boxmap2[b[1], (b[2]-1)*2+2] = ']'
        end
    end
    display(boxmap2)
    bm_copy = copy(boxmap2)
    for d in instr
        p = findfirst(boxmap2 .== '@')
        bm_copy = copy!(bm_copy, boxmap2) # for undoing if it went wrong
        pushed = push_object2!(boxmap2, p, d)
        println()
        if !pushed
            copy!(boxmap2, bm_copy)
            println("Restored map")
        end
    end
    display(boxmap2)
    println("score = $(score_map2(boxmap2))")

end

# part 2 doesn't seem so bad. We just need to add logic to also push the other side of a box
# if direction is up or down
# the problem here is that we need tosee other other side of the tree to know if we can move or not.
# maybe one solution is to simply check if ANY moves failed, and then revert everything if so

go2("day15/test")
go2("day15/input")
