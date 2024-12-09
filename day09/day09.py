# seems like we can get away with a dense array
# input is 10_000 long, so that's only 1 MB of RAM

import time
import numpy as np

def go(filename: str, debug=True):
    with open(filename, "r") as f:
        inp = f.readline()
    dense_disk: list[int] = []
    
    # first we read the input into the dense array
    id = 0
    gap = False
    for n in inp:
        if not gap:
            dense_disk += [id] * int(n)
            id += 1
            gap = True
        else:
            dense_disk += [-1] * int(n)
            gap = False
    #if debug: print(dense_disk)

    # now we clone the input, and walk through it, replaceing
    # every -1 we see
    sorted_disk = np.array(dense_disk, copy=True)
    total_files = np.sum(sorted_disk != -1)
    total_blanks = np.sum(sorted_disk == -1)
    copies = 0
    file_idx = len(sorted_disk) - 1
    for i in range(len(sorted_disk)):
        if sorted_disk[i] == -1:
            sorted_disk[i] = sorted_disk[file_idx]
            sorted_disk[file_idx] = -1
            file_idx -= 1
            copies += 1
            first_blank = np.where(sorted_disk==-1)[0][0] # dirty and you love it
            if np.all(sorted_disk[first_blank:] == -1):
                print(f"checksum = {np.sum(sorted_disk[:first_blank] * np.arange(first_blank))}")
                break
            while sorted_disk[file_idx] == -1: # loop past any gaps at the end
                file_idx -= 1
      #  if i > (total_files+1): # -2 because....
      #      break

def go2(filename: str, debug=True):
    with open(filename, "r") as f:
        inp = f.readline()
    dense_disk: list[int] = []
    # we need to know hwere the gaps are for filling in later
    gaps = []
    gap_inds = []
    # print(gaps)
    # first we read the input into the dense array
    id = 0
    gap = False
    ind = 0
    for (n) in inp:
        if not gap:
            dense_disk += [id] * int(n)
            id += 1
            gap = True
        else:
            dense_disk += [-1] * int(n)
            gap = False
            gaps.append(int(n))
            gap_inds.append(ind)
        ind += int(n)

    disk = np.array(dense_disk)
    gaps = np.array(gaps)
    gap_inds = np.array(gap_inds)

    for file_id in range(disk[-1], -1, -1):
        # for each file, check if there is space, and copy it if so
        file_length = np.sum(disk==file_id)
        first_gap = np.where(gaps >= file_length)[0]
        if len(first_gap) != 0:
            first_gap = first_gap[0]
            file_ind = np.where(disk == file_id)[0][0]
            if first_gap >= file_id:
                continue # don't copy file to a later position
            disk[disk == file_id] = -1
            disk[gap_inds[first_gap]:gap_inds[first_gap]+file_length] = file_id
            gaps[first_gap] -= file_length
            gap_inds[first_gap] += file_length
            if gaps[first_gap] < 0:
                print("oh no")
    disk[disk == -1] = 0 # just zero it out for the checksum
    print(f"checksum = {np.sum(disk * np.arange(len(disk)))}")


# part 2 looks easier if anything, since it's simpler to work out when we're done
# We already have the list of available gaps from our input

go("day09/test.txt")
go("day09/input.txt")
print("********************")
go2("day09/test.txt")
go2("day09/input.txt")
