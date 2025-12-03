import datetime

start_time = datetime.datetime.now()

def findMaxDigits(line: str, k: int = 12) -> int:
    # instead of trying every possible combination of k digits (which would be insane),
    # we use a greedy approach: pick the best digit at each step, left to right.
    #
    # to maximize a number, you want the leftmost digit to be as big as possible.
    # then the second digit, then the third, etc. so we just greedily pick the max each time.
    #
    # but we can't just pick from anywhere.
    #   - if we pick too far right, we won't have enough digits left to fill k slots.
    #   - if we pick too early, we might miss a bigger digit that could've fit.
    #
    # algorithm:
    #
    # 1. for each of the k digits we need to pick, figure out the valid search window.
    #    the window is [start, end] where:
    #      - start = position right after our previous pick (or 0 for the first pick)
    #      - end = n - (k - i), where i is how many digits we've already picked
    #
    #    why this formula? we still need (k - i) digits after this pick.
    #    so the latest we can pick from is position n - (k - i), leaving exactly
    #    enough room for the remaining digits.
    #
    # 2. find the maximum digit in that window and lock it in.
    #    move our start position past where we picked.
    #
    # 3. repeat until we have k digits.
    #
    # example: "234234234234278" with k=12 (length n=15)
    #
    #   the string has 15 digits, but we only want 12. so we're dropping 3 digits.
    #   which 3 do we drop to get the biggest number? let's walk through it.
    #
    #   position:  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14
    #   digit:     2  3  4  2  3  4  2  3  4  2  3  4  2  7  8
    #
    #   i=0: picking digit 1 of 12. we still need 12 digits after this.
    #        that means we can't pick past position 15 - 12 = 3 (or we'd run out of room).
    #        search window [0, 3] → '2','3','4','2'
    #        best choice: '4' at position 2
    #        result so far: "4"
    #
    #   i=1: picking digit 2 of 12. we still need 11 more.
    #        start after position 2, so start = 3.
    #        can't pick past position 15 - 11 = 4.
    #        search window [3, 4] → '2','3'
    #        best choice: '3' at position 4
    #        result so far: "43"
    #
    #   i=2: picking digit 3 of 12. we still need 10 more.
    #        start = 5, can't pick past 15 - 10 = 5.
    #        search window [5, 5] → just '4'
    #        no choice here, take '4'
    #        result so far: "434"
    #
    #   from here on, the window is always size 1 (start == end), so we just
    #   take each remaining digit in order: '2','3','4','2','3','4','2','7','8'
    #
    #   final result: "434234234278"
    #
    #   notice: we skipped the '2' at position 0, '3' at position 1, and '2' at position 3.
    #   those were the "worst" digits we could afford to drop while maximizing the result.
    #
    # optimization: if we find a '9' in the window, we can stop searching immediately.
    # can't do better than 9, so why keep looking?
    #
    # this way we pick k digits in O(n × k) worst case, instead of checking
    # all C(n, k) combinations. way faster!

    n = len(line)
    result = []
    start = 0
    
    for i in range(k):
        end = n - (k - i)  # last valid position for this pick
        
        max_char = '0'
        max_pos = start
        for j in range(start, end + 1):
            if line[j] > max_char:
                max_char = line[j]
                max_pos = j
                if max_char == '9':  # can't beat 9, stop early
                    break
        
        result.append(max_char)
        start = max_pos + 1
    
    return int(''.join(result))

total = 0

with open('data/day3/day3.txt', 'r') as f:
    lines = f.read().splitlines()
    for line in lines:
        total += findMaxDigits(line)

end_time = datetime.datetime.now()
time_taken = (end_time - start_time).total_seconds() * 1000
print("Time taken: ", time_taken, "ms")
print("Total: ", total)