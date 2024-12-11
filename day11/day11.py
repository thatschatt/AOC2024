# so using python seems like cheating here, because the gotcha
# in this task is 64 bit integer overflow. But python automatically 
# switches to big ints, so i don't even have to care

import math
import time


def blink(stones: list[int]):
    stones_out = []
    for s in stones:
        try:
            num_digits = math.floor(math.log10(s) + 1)
        except ValueError: # log10 fails on a zero
            stones_out.append(1)
            continue
        if num_digits % 2 == 0: # even number
            # pretty sure just using strings will be faster
            # than trying to computer logarithms of 80 bit numbers
            stones_out.append(int(repr(s)[:num_digits//2]))
            stones_out.append(int(repr(s)[num_digits//2:]))
        else:
            stones_out.append(s * 2024)
    return stones_out

# leaving in the crappy solution is a message from the past
def go(filename: str, n_blink):
    with open(filename, "r") as f:
        inp = f.readline()
    stones = [int(n) for n in inp.split(" ")]
    print(f"after {0} blinks: {len(stones)} stones")
    for n in range(n_blink):
        stones = blink(stones)
        print(stones)
        print(f"after {n+1} blinks: {len(stones)} stones")


def blink_stone(stone: int, n_blinks: int, memo: dict[tuple[int, int], int]=dict()) -> int:
    """blink a single stone recursively. Returns
    total number of blinks"""
    if n_blinks == 0:
        return 1
    if (stone, n_blinks,) in memo:
        return memo[(stone, n_blinks,)]
    
    s_str = repr(stone)
    num_digits = len(s_str)
    n_stones = 0

    if stone == 0:
        n_stones += blink_stone(1, n_blinks-1, memo)
    elif num_digits % 2 == 0: # even number
        # pretty sure just using strings will be faster
        # than trying to computer logarithms of 80 bit numbers
        n_stones += blink_stone(int(s_str[:num_digits//2]), n_blinks-1, memo)
        n_stones += blink_stone(int(s_str[num_digits//2:]), n_blinks-1, memo)
    else:
        n_stones += blink_stone(stone * 2024, n_blinks-1, memo)
    memo[(stone, n_blinks,)] = n_stones
    return n_stones

def go2(filename: str, n_blink):
    with open(filename, "r") as f:
        inp = f.readline()
    stones = [int(n) for n in inp.split(" ")]
    n_stones = 0
    memo = dict()
    for s in stones:
        n = blink_stone(s, n_blink, memo)
        print(f"{s} -> {n}")
        n_stones += n
    print(f"total stones after {n_blink} blinks = {n_stones}")
    print(f"memo size = {len(memo)}")

# ok. So clearly we can't just run this code 75 times and expect it
# to work. SO what are out options?
# even after 40 blinks, the array is a gigabyte or so
#
# is there a clever trick to assume what wil hapen from any given stone?
# everything is totall linear, so can we memoize?
# but i still need to know the values at any given point?
#
# so first thought is i need to go depth first rather than bredth
# This way i don't choke on memory at least, and maybe can do
# some sort of memoizing.

go2("day11/test.txt", n_blink=25)
go2("day11/input.txt", n_blink=25)

t1 = time.time()
go2("day11/input.txt", n_blink=75)
print(f"took {time.time() - t1:0.2f} s")