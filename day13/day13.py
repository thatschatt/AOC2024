from scipy.optimize import linprog
from scipy.linalg import solve
import numpy as np
import scanf

def solve_claw(A_dir, B_dir, P_dir, addition=0):
    c = np.array([3, 1]) # objective function

    A_eq = np.array([[A_dir[0], B_dir[0]], 
                            [A_dir[1], B_dir[1]]])
    b_eq = np.array([P_dir[0] + addition, P_dir[1] + addition], dtype=np.int64)

  #  print(b_eq)
  #  result = linprog(c, A_eq=A_eq, b_eq=b_eq, integrality=[1, 1])
  #  print(result)
  # # print(result.message)
  #  if result.success:
  #      print(f"{np.int64(A_eq @ result.x) - np.int64(b_eq)}")
  #      #return int(result.x[0])*3 + int(result.x[1])
    
    # try it without minimizing?
    # and looks like I manually have to cooerce almost intos to be ints
    # probably should have solved the equations manually
    x = solve(A_eq, b_eq)
    if np.all(np.abs(x - np.round(x)) < 0.0001):
        return int(np.round(x[0]))*3 + int(np.round(x[1]))
    print(f"solve version {np.int64(A_eq @ x) - np.int64(b_eq)} is int: {np.abs(x - np.floor(x)) < 0.0001}")
    return 0


def go(filename: str):
    with open(filename, "r") as f:
        price = 0
        while True:
            A_line = f.readline()
            B_line = f.readline()
            P_line = f.readline()
            f.readline() # skip next line
            if A_line == "": break
       #     print(A_line, B_line, P_line)
            A_dir = scanf.scanf("Button A: X+%d, Y+%d", A_line)
            B_dir = scanf.scanf("Button B: X+%d, Y+%d", B_line)
            P_dir = scanf.scanf("Prize: X=%d, Y=%d", P_line)
            price += solve_claw(A_dir, B_dir, P_dir, addition=10_000_000_000_000)
    print(f"total price = {price}")

go("day13/test.txt")
go("day13/input.txt")