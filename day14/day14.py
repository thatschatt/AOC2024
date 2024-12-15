import numpy as np
import scanf

def quad_after_t(p: np.ndarray, v: np.ndarray, t: int, width: int, height: int):
    p = p + v * t
    p[0] = p[0] % width
    p[1] = p[1] % height
    if (p[0] < width // 2) and (p[1] < height // 2):
        return "NW"
    if (p[0] > width // 2) and (p[1] < height // 2):
        return "NE"
    if (p[0] > width // 2) and (p[1] > height // 2):
        return "SE"
    if (p[0] < width // 2) and (p[1] > height // 2):
        return "SW"
    return 'none'

def move_bots(ps, vs, steps=1):
    for n in range(len(ps)):
        ps[n] = ps[n] + vs[n]*steps
        ps[n][0] = ps[n][0] % 101
        ps[n][1] = ps[n][1] % 103

def print_board(ps: list[np.ndarray]):
    board = np.full((101, 103), '.')
    for p in ps:
        board[p[0], p[1]] = '*'
    np.set_printoptions(threshold=101*103, linewidth=120)
    print(chr(27) + "[2J")
    print(np.array2string(board.T, separator='', formatter={'str_kind': lambda x: x}), '\n')

def go2(filename: str):
    ps: list[np.ndarray] = []
    vs: list[np.ndarray] = []
    with open(filename, "r") as f:
        for l in f.readlines():
            (px, py, vx, vy) = scanf.scanf("p=%d,%d v=%d,%d", l) # type: ignore
            ps.append(np.array([px, py]))
            vs.append(np.array([vx, vy]))
    
    print_board(ps)
#    move_bots(ps, vs, 65)
    move_bots(ps, vs, 65 + 103*75)
    print_board(ps)

#    for t in range(65+103):
#        move_bots(ps, vs, 103)
#        print_board(ps)
#        input(f"Finished step {t + 1}")
   # print_board(ps)
    

def go(filename: str, width, height):
    quadcount = {'NW': 0, 'NE': 0, 'SW': 0, 'SE': 0, 'none': 0}
    with open(filename, "r") as f:
        for l in f.readlines():
            (px, py, vx, vy) = scanf.scanf("p=%d,%d v=%d,%d", l) # type: ignore
            quad = quad_after_t(np.array([px, py]), np.array([vx, vy]), 100, width, height)
            quadcount[quad] += 1
    print(quadcount["NE"] * quadcount["NW"] * quadcount["SE"] * quadcount["SW"])

# part 2: step through and see if anything pops up?

# so basically I manually stepped through a bunch of stuff until i saw pictures, then iterated steps of 101/103 from there
# until i found the christmas tree

go("day14/test.txt", 11, 7)
go("day14/input.txt", 101, 103)
go2("day14/input.txt",)
