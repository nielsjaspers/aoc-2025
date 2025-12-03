import time

start_time = time.time()

def sortDigits(line: str) -> int:
    num1 = line[0]
    num2 = '0'
    n = len(line)

    for i in range(1, n - 1):
        digit = line[i]
        if num1 == '9' and num2 == '9':
            return 99
        if num1 < digit:
            num1 = digit
            num2 = '0'
        elif num2 < digit and num1 != digit:
            num2 = digit
        elif num1 == digit:
            num2 = digit

    digit = line[n - 1]
    if num1 != '9' or num2 != '9':
        if num2 < digit:
            num2 = digit

    # convert characters to integers by subtracting 48 (ASCII value of '0')
    return (ord(num1) - 48) * 10 + (ord(num2) - 48)
    
total = 0

with open('data/day3/day3.txt', 'r') as f:
    lines = f.read().splitlines()
    for line in lines:
        total += sortDigits(line)

end_time = time.time()
print("Time taken: ", (end_time - start_time) * 1000, "ms")
print("Total: ", total)