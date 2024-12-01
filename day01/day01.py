import numpy as np


def go(filename: str):
    loc_id = np.loadtxt(filename, dtype=np.int32)
    loc_id[:, 0] = np.sort(loc_id[:, 0])
    loc_id[:, 1] = np.sort(loc_id[:, 1])
    # part 1
    print(
        f"file = {filename}, total distance = {np.sum(np.abs(loc_id[:,0] - loc_id[:,1]))}"
    )

    # part 2
    sim_score = 0
    for n in loc_id[:, 0]:
        sim_score += np.sum(loc_id[:, 1] == n) * n
    print(f"file = {filename}, simularity score = {sim_score}")


go("day01/test.txt")
go("day01/input.txt")
