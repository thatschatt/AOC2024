from typing import Literal
from math import log10
import time

# part 1 feels like it needs a recursive search to find all possible combinations of
# operators, which we then evaluate.
#
# It looks like we never have more than 12 inputs per line, which is 4096 combinations. Not too bad.
# Note that numbers get very large, so we have to be sure we are working with 64 bits,
#   but I tihnk that's defalt in python??


def eval_calibration(numbers: list[int], operators: list[Literal["+", "*", "|"]]) -> int:
    accum = numbers[0]
    for n in range(1, len(numbers)):
        if operators[n - 1] == "+":
            accum += numbers[n]
        elif operators[n - 1] == "*":
            accum *= numbers[n]
        elif operators[n - 1] == "|":
            accum = accum * 10 ** (1 + int(log10(numbers[n]))) + numbers[n]
    return accum


def try_operators(numbers: list[int], result, operators: list[Literal["+", "*"]] = []):
    """recursively try different operators. Try appending both a '+' and '*'
    and do an eval if we are at full length"""
    # do the evaluation if we are at full length
    if len(operators) == (len(numbers) - 1):
        return eval_calibration(numbers, operators) == result
    # this has no early return, but meh
    return try_operators(numbers, result, operators=operators + ["+"]) or try_operators(
        numbers, result, operators=operators + ["*"]
    )


def try_operators_2(numbers: list[int], result, operators: list[Literal["+", "*", "|"]] = []):
    """recursively try different operators. Try appending both a '+' and '*'
    and do an eval if we are at full length"""
    # do the evaluation if we are at full length
    if len(operators) == (len(numbers) - 1):
        return eval_calibration(numbers, operators) == result
    # I could probably make this go a lot faster by passing indices rather than list slice
    # 10 seconds ain't so bad though
    return (
        try_operators_2(numbers, result, operators=operators + ["+"])
        or try_operators_2(numbers, result, operators=operators + ["*"])
        or try_operators_2(numbers, result, operators=operators + ["|"])
    )


def go(filename: str):
    total = 0
    with open(filename, "r") as f:
        for line in f:
            ress, remain = line.split(":")
            res = int(ress)
            nums = [int(a) for a in remain.strip().split(" ")]
            if try_operators(nums, res):
                print(f"{line.strip()} |  good")
                total += res
    print(f"Total good values = {total}")


def go2(filename: str):
    total = 0
    with open(filename, "r") as f:
        for line in f:
            ress, remain = line.split(":")
            res = int(ress)
            nums = [int(a) for a in remain.strip().split(" ")]
            if try_operators_2(nums, res):
                print(f"{line.strip()} |  good")
                total += res
    print(f"Total good values = {total}")


print(f"testing [81 + 40 * 27], expect 3267: {eval_calibration([81, 40, 27], ['+', '*'])}")
print(f"testing [81 * 40 + 27], expect 3267: {eval_calibration([81, 40, 27], ['*', '+'])}")
print(f"testing [11 + 6 * 16 + 20], expect 292: {eval_calibration([11, 6, 16, 20], ['+', '*', '+'])}")
print(f"testing [15 | 6], expect 156: {eval_calibration([15, 6], ['|'])}")
print(f"testing [6*8|6*15], expect 7290: {eval_calibration([6, 8, 6, 15], ['*', '|', '*'])}")

print(try_operators([11, 6, 16, 20], 292))

# part 2 just needs another op. Seems easy enough. Total evals will go up to like 5M,
# which is a 1000x increase. I don't think that'll hurt too much

go("day07/test.txt")
print("*******************")
go2("day07/test.txt")
print("*******************")
go("day07/input.txt")
print("*******************")
t1 = time.time()
go2("day07/input.txt")
print(f"took {time.time() - t1} s")
