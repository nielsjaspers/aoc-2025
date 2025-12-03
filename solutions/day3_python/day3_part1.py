import datetime

start_time = datetime.datetime.now()

def sortDigits(line: str) -> int:
    num1 = line[0]
    num2 = '0'

    for digit in line[1:-1]:
        if num1 == '9' and num2 == '9':
            return 99
        if num1 < digit:
            num1 = digit
            num2 = '0'
        elif num1 == digit or num2 < digit:
            num2 = digit

    digit = line[-1]
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

end_time = datetime.datetime.now()
time_taken = (end_time - start_time).total_seconds() * 1000
print("Time taken: ", time_taken, "ms")
print("Total: ", total)