import numpy as np


# input isn't super long - we can get away with simple brute forcing
# start by building a dict of each number, and all the numbers that
#   must be smaller than it. Then just plow through and check everything
#   matches up

# For part two, every time we encounter a bad pair of numbers we swap them
# and rerun for that set. Eventually this will converge on the sorted set.
# There's probably a very clena algorithm for doing this better, but meh.


def check_pages(pages: dict[int, list[int]], ps):
    for i, n1 in enumerate(ps):
        if not n1 in pages.keys():
            continue  # skip if we don't have any entries
        for j, n2 in enumerate(ps[i + 1 :]):
            if n2 in pages[n1]:
                return (i, j + i + 1)  # return bad indices if there is a violation
    return (-1, -1)  # or -1 if it was good


def go(filename: str):
    pages: dict[int, list[int]] = {}
    section = 0
    middle_nos = 0
    middle_nos_2 = 0
    with open(filename, "r") as f:
        for line in f:
            if line == "\n":
                section = 1
            elif section == 0:
                p2, p1 = [int(n) for n in (line.split("|"))]
                try:
                    pages[p1].append(p2)
                except:
                    pages[p1] = [p2]
            else:
                # now we just have to check everything
                ps = [int(n) for n in (line.split(","))]
                goodpage = check_pages(pages, ps) == (-1, -1)
                if goodpage:
                    print(f"{line.strip()} is good")
                    middle_nos += ps[len(ps) // 2]
                else:
                    print(f"{line.strip()} is bad")
                    # now to fix this one
                    while not goodpage:
                        (i, j) = check_pages(pages, ps)
                        if (i, j) == (-1, -1):
                            goodpage = True
                        else:
                            temp = ps[i]
                            ps[i] = ps[j]
                            ps[j] = temp
                            print(f"sorted it to {ps}")
                    middle_nos_2 += ps[len(ps) // 2]

    print(f"sum of middle no.s = {middle_nos}")
    print(f"sum of corrected middle no.s = {middle_nos_2}")


go("day05/test.txt")
print("*******************")
go("day05/input.txt")
