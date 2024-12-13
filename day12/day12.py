import numpy as np
# looks like a classic case for a flood fill 
#    first pass i will turn the first available patch into * symbols
#    then i'll count the neighbors of each *
#    convert all * into . before the next field is attempted

def floodfill(garden: np.ndarray, row: int, col: int, symbol: str):
    if (row < 0) or (col < 0): return
    try:
        if garden[row, col] != symbol: return
    except IndexError:
        return
    garden[row, col] = '*'
    floodfill(garden, row-1, col, symbol)
    floodfill(garden, row+1, col, symbol)
    floodfill(garden, row, col-1, symbol)
    floodfill(garden, row, col+1, symbol)

def score_region(garden: np.ndarray, symbol: str = '*'):
    area = 0
    edges = 0
    for r in range(garden.shape[0]):
        for c in range(garden.shape[1]):
            if garden[r, c] == symbol:
                area += 1
                edges += 4 # take one off for each neighbor
                if r > 0 and (garden[r-1, c] == symbol): edges -= 1
                if r < garden.shape[0]-1 and (garden[r+1, c] == symbol): edges -= 1
                if c > 0 and (garden[r, c-1] == symbol): edges -= 1
                if c < garden.shape[1]-1 and (garden[r, c+1] == symbol): edges -= 1
    #print(f"area = {area}, edges={edges}")
    return (area * edges)

def count_corners(garden: np.ndarray, symbol: str = '*'):
    """let's work out what each pattern gets:
     
    ...
    .#.
    ...
    --> isolated: 4 corners
    
    ...
    ##.
    ...
    --> 1 neighbour: 2 corners always

    ...
    ###
    ...
    --> 2 straight neighbours: 0 corners always

    ...  ...  ..#  #..  
    .##  .##  .##  .##  
    .#.  .##  .#.  .#.  
     2    1    2    2
    --> 2 diagonal neighbours: 2 corners unless the square between is filled

    ...  #..  ...  ...
    ###  ###  ###  ###
    .#.  .#.  ##.  ###
     2    2    1    0
    --> 3 neghbours: depends

    .#.  ##.  ###  ###  ###
    ###  ###  ###  ###  ###
    .#.  .#.  .#.  ##.  ###
     4    3    2    1    0
    --> 4 neighbours: equal to number of vacant diagonal spots

    Gonna be tedious to code all of these, especially considering rotation.
    
    """
    corners = 0
    for r in range(garden.shape[0]):
        for c in range(garden.shape[1]):
            if garden[r, c] == symbol:
                ...


def wipe_region(garden: np.ndarray, symbol: str):
    garden[garden == '*'] = symbol.lower()

def go(filename:str):
    with open(filename, 'r') as f:
        lines = f.readlines()
        garden = np.array([list(line.strip()) for line in lines])
        garden_low = np.array([list(line.lower().strip()) for line in lines])

    total = 0
    for r in range(garden.shape[0]):
        for c in range(garden.shape[1]):
            if garden[r, c].isupper():
                symbol = garden[r, c]
                floodfill(garden, r, c, symbol)
                score = score_region(garden)
                print(f"region {symbol}, price = {score}")
                wipe_region(garden, symbol)
                total += score
    print(f"total = {total}")
    print(np.all(garden_low == garden))

go ("day12/test.txt")
print('**************')
#go ("day12/input.txt")