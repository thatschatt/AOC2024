# so in this one I will have a 3D *x, y, direction) map dense matrix to represent where we've visited.
# For each node, push the 3 accessible nodes (turn left, turn right, go forwards) into the queue of nodes
#   that need to be visited, along with their cost. Then, sort all the ndoes by cost and vist the next
#   cheapest one. This should find the cheapest route fiarly simply, but probably kicks my ass in part two.

const global directions = Dict(
    '>' => CartesianIndex(0, 1), # 0 For some reason i felt like 0-indexing would be easier than fixing the one place it comes up (the mod function)
    'v' => CartesianIndex(1, 0), # 1
    '<' => CartesianIndex(0, -1), # 2
    '^' => CartesianIndex(-1, 0), # 3
    )

const global dir_chars = ['>', 'v', '<', '^']

# there are thousands of smarter ways to do this but whatever
const global dir_ints = [
    CartesianIndex(0, 1), # 0
    CartesianIndex(1, 0), # 1
    CartesianIndex(0, -1), # 2
    CartesianIndex(-1, 0), # 3
]

# let's use a struct today. Maybe that beats a tutple?
struct NodeToVisit
    coord:: CartesianIndex
    dir:: Int32 # can be one of the directions
    cost:: Int32
end

function visit_next!(mazemap, visited, visit_list::Vector{NodeToVisit})
    i = sortperm([v.cost for v in visit_list])
    visit_list[:] = visit_list[i] # should sort it
    next_point = popfirst!(visit_list)
    if visited[next_point.coord[1], next_point.coord[2], next_point.dir+1] == 2^30
        if mazemap[next_point.coord] == 'E'
            return next_point
        end
        if mazemap[next_point.coord] == '#'
            return 0
        end
        mazemap[next_point.coord] = dir_chars[next_point.dir+1]
        visited[next_point.coord[1], next_point.coord[2], next_point.dir+1] = next_point.cost # save the cost for part 2

        push!(visit_list, NodeToVisit(next_point.coord, (next_point.dir+1)%4, next_point.cost+1000)) # turn right
        push!(visit_list, NodeToVisit(next_point.coord, (next_point.dir+3)%4, next_point.cost+1000)) # turn left (+3 wraps us round)
        push!(visit_list, NodeToVisit(next_point.coord + dir_ints[next_point.dir + 1], next_point.dir, next_point.cost+1)) # go straight
    end
    return 0
end

function find_best_nodes!(current_node::NodeToVisit, scores::Array{Int, 3}, good_nodes::Set{CartesianIndex})
    # we look at the adjacent nodes, and can go there if score is 1 lower
    # the nodes on the parallel direciton planes are accessible if they are 1000 lower
    # do this by direction

    # this for sure doesn't have to be 12 individual if statements. But it works
    push!(good_nodes, current_node.coord)
    if current_node.dir == 0 # >
        if scores[current_node.coord[1], current_node.coord[2]-1, 0+1] == current_node.cost-1 # moved from the left
            find_best_nodes!(NodeToVisit(current_node.coord + directions['<'], current_node.dir, current_node.cost-1), scores, good_nodes)
        end
        if scores[current_node.coord[1], current_node.coord[2], 1+1] == current_node.cost-1000 # turned from up
            find_best_nodes!(NodeToVisit(current_node.coord, 1, current_node.cost-1000), scores, good_nodes)
        end
        if scores[current_node.coord[1], current_node.coord[2], 3+1] == current_node.cost-1000 # turned from down
            find_best_nodes!(NodeToVisit(current_node.coord, 3, current_node.cost-1000), scores, good_nodes)
        end
    elseif current_node.dir == 1 # v
        if scores[current_node.coord[1]-1, current_node.coord[2], 1+1] == current_node.cost-1 # moved from above
            find_best_nodes!(NodeToVisit(current_node.coord + directions['^'], current_node.dir, current_node.cost-1), scores, good_nodes)
        end
        if scores[current_node.coord[1], current_node.coord[2], 0+1] == current_node.cost-1000 # turned from right
            find_best_nodes!(NodeToVisit(current_node.coord, 0, current_node.cost-1000), scores, good_nodes)
        end
        if scores[current_node.coord[1], current_node.coord[2], 2+1] == current_node.cost-1000 # turned from left
            find_best_nodes!(NodeToVisit(current_node.coord, 2, current_node.cost-1000), scores, good_nodes)
        end
    elseif current_node.dir == 2 # <
        if scores[current_node.coord[1], current_node.coord[2]+1, 2+1] == current_node.cost-1 # moved the right
            find_best_nodes!(NodeToVisit(current_node.coord + directions['>'], current_node.dir, current_node.cost-1), scores, good_nodes)
        end
        if scores[current_node.coord[1], current_node.coord[2], 1+1] == current_node.cost-1000 # turned from up
            find_best_nodes!(NodeToVisit(current_node.coord, 1, current_node.cost-1000), scores, good_nodes)
        end
        if scores[current_node.coord[1], current_node.coord[2], 3+1] == current_node.cost-1000 # turned from left
            find_best_nodes!(NodeToVisit(current_node.coord, 3, current_node.cost-1000), scores, good_nodes)
        end
    elseif current_node.dir == 3 # ^
        if scores[current_node.coord[1]+1, current_node.coord[2], 3+1] == current_node.cost-1 # moved from below
            find_best_nodes!(NodeToVisit(current_node.coord + directions['v'], current_node.dir, current_node.cost-1), scores, good_nodes)
        end
        if scores[current_node.coord[1], current_node.coord[2], 0+1] == current_node.cost-1000 # turned from right
            find_best_nodes!(NodeToVisit(current_node.coord, 0, current_node.cost-1000), scores, good_nodes)
        end
        if scores[current_node.coord[1], current_node.coord[2], 2+1] == current_node.cost-1000 # turned from left
            find_best_nodes!(NodeToVisit(current_node.coord, 2, current_node.cost-1000), scores, good_nodes)
        end
    end
end

function go(filename)
    display(filename)
    lines = readlines(filename)
    mazemap = reduce(vcat, permutedims.(collect.(lines)))
    visited = ones(Int, (size(mazemap)[1],  size(mazemap)[2], 4)) .* 2^30 # every point has an awful score to start
    visit_list = [NodeToVisit(findfirst(mazemap .== 'S'), 0, 0)]
    end_node = NodeToVisit(findfirst(mazemap .== 'E'), 0, 0)

    for n in 1:200_000
        if length(visit_list) == 0
            println("done after $n iterations")
            break
        end
        success = visit_next!(mazemap, visited, visit_list)
        if typeof(success) == NodeToVisit && end_node.cost == 0
            display(mazemap)
            display(success)
            println("end found after $n iterations. Score = $(success.cost)")
            end_node = success
        end
    end
    display(mazemap)
    println("Now finding all good points")

    s::Set{CartesianIndex} = Set()
    find_best_nodes!(end_node, visited, s)
    display(s)
end

# so for part two, I tihnk i can get away with saving the best score for every point, and then recursively
# searching for every point which is 1 move away from the final step.

# maybe not even that painful?? I guess I'll have to make sure the mapping is exhastive - run until the visit list is empty?

go("day16/test.txt")
go("day16/input.txt")