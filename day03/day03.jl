using Scanf

function go(filename)
    # N.B. MAKE SURE THE FILE IS SAVED WITH LF LINE ENDINGS!
    input = replace(read(filename, String), "\n" => "*****REPLACE****")
    reg = r"mul\(\d{1,3},\d{1,3}\)"

    score = 0
    for m in eachmatch(reg, input)
        _, n1, n2 =  @scanf(m.match, "mul(%d,%d)", Int, Int)
        # println(n1, n2)
        score += n1 * n2
    end
    println("part 1 score = $(score)")
    println("#########\n\n")

    ### part 2
    score = 0
    init_reg = r"^(.+?)don't\(\)"
    # this should do a lazy look ahead where each section must end with a 'don't()'
    main_reg = r"do\(\)(.+?)(?=don't\(\))" 

    # first just do the iniital part
    try
        init_part = match(init_reg, input).match
        for m in eachmatch(reg, init_part)
            _, n1, n2 =  @scanf(m.match, "mul(%d,%d)", Int, Int)
            # println(n1, n2)
            score += n1 * n2
        end
    catch
        println("No initial part found")
    end

    # now the main bit
    for doblock in eachmatch(main_reg, input)
        println(doblock.match)
        println("*********")
        for m in eachmatch(reg, doblock.match)
       #     println(m.match)
            _, n1, n2 =  @scanf(m.match, "mul(%d,%d)", Int, Int)
            # println(n1, n2)
            score += n1 * n2
        end
    end
    println("part 2 score = $(score)")
    println("#########\n\n")


end

# for part two I should be able to do large regex matches of the do() and don't() brackets

go("day03/test.txt")
go("day03/input.txt")