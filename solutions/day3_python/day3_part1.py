import time

start_time = time.time()

def sortDigits(line: str) -> int:
    num1 = int(line[0])
    num2 = 0
    n = len(line)

    for i in range(1, n - 1):
        digit = int(line[i])
        if num1 == 9 and num2 == 9:
            return 99
        if num1 < digit:
            num1 = digit
            num2 = 0
        elif num2 < digit and num1 != digit:
            num2 = digit
        elif num1 == digit:
            num2 = digit

    digit = int(line[n - 1])
    if num1 != 9 or num2 != 9:
        if num2 < digit:
            num2 = digit

    return num1 * 10 + num2
    
total = 0

with open('data/day3/day3.txt', 'r') as f:
    for line in f:
        line = line.rstrip('\n')

        total += sortDigits(line)
        # print(sorted_digits)

end_time = time.time()
print("Time taken: ", (end_time - start_time) * 1000, "ms")
print("Total: ", total)