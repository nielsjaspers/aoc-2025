import time

start_time = time.time()

def sortDigits(digits: list[int]) -> int:
    num1 = 0
    num2 = 0

    for i, digit in enumerate[int](digits):
        if i != len(digits) - 1:
            # print(digit,num1,num2)
            if num1 < digit:
                num1 = digit
                num2 = 0
                continue
            if num2 < digit and num1 != digit:
                num2 = digit
                continue
            if num1 == digit:
                num2 = digit
                continue
        else:
            if num2 < digit:
                num2 = digit
                continue
            if num2 == digit:
                num2 = digit
                continue

    # returning num1 * 10 + num2 is faster than first converting to string and then converting to int to append the digits
    return (num1 * 10) + num2
total = 0

with open('data/day3/day3.txt', 'r') as f:
    for line_number, line in enumerate(f):
        line = line.strip()

        digits = [int(char) for char in line]
        sorted_digits = sortDigits(digits)
        total += sorted_digits
        # print(sorted_digits)

end_time = time.time()
print("Time taken: ", (end_time - start_time) * 1000, "ms")
print("Total: ", total)