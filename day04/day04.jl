
function is_xmas(letters, row, col, r_inc, c_inc)
    try
        st = [letters[row+n*r_inc, col+n*c_inc] for n in 0:3]
        if (st == ['X', 'M', 'A', 'S'])
            return 1
        end
    catch
    end
    return 0
end

function is_mas(letters, row , col, inc)
    try
        st = [letters[row+n, col+n*inc] for n in -1:1]
        if (st == ['M', 'A', 'S'])
            return 1
        end
        if (st == ['S', 'A', 'M'])
            return 1
        end
    catch
    end
    return 0
end

function go(filename)
    lines = readlines(filename)
    letters = reduce(vcat, permutedims.(collect.(lines)))
    score = 0
    score_part2 = 0
    for r in 1:size(letters, 1)
        for c in 1:size(letters, 2)
            score += is_xmas(letters, r, c, 0, -1) # <--
            score += is_xmas(letters, r, c, -1, -1) # \
            score += is_xmas(letters, r, c, -1, 0) # ^
            score += is_xmas(letters, r, c, -1, 1) # /
            score += is_xmas(letters, r, c, 0, 1) # -->
            score += is_xmas(letters, r, c, 1, 1) # \
            score += is_xmas(letters, r, c, 1, 0) # v
            score += is_xmas(letters, r, c, 1, -1) # /

            score_part2 += (is_mas(letters, r, c, +1) & is_mas(letters, r, c, -1))
        end
    end
    return (score, score_part2)
end

# for part 2 just make a function that checks each diagonal, then returns an and. seems easy.

display(go("day04/test.txt"))
display(go("day04/input.txt"))