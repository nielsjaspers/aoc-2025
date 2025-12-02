local time_start = os.clock()

local function split(str, delimiter)
    local result = {}
    local start = 1
    local delimiter_pos = string.find(str, delimiter, start, true)
    
    while delimiter_pos do
        table.insert(result, string.sub(str, start, delimiter_pos - 1))
        start = delimiter_pos + 1
        delimiter_pos = string.find(str, delimiter, start, true)
    end
    
    if start <= #str then
        table.insert(result, string.sub(str, start))
    end
    
    return result
end

local file = io.open("data/day2/day2.txt", "r")

local numbers = {}

if file then
    local line = file:read("*line")
    -- print(line)
    if line then
        local ranges = split(line, ",")
        for _, range in ipairs(ranges) do
            local dash_pos = string.find(range, "-")
            local s = tonumber(string.sub(range, 1, dash_pos - 1)) -- start string
            local e = tonumber(string.sub(range, dash_pos + 1))    -- end string
            
            -- instead of checking every number in the range (which can be millions, btw),
            -- we generate only numbers where the left half equals the right half.
            --
            -- the trick: numbers like 11, 1212, 100100 follow a pattern.
            -- 
            -- for a number with an even number of digits (say, 2*k digits where k is half the number of digits)
            -- (this is because you want to check if the left half equals the right half)
            -- so if the left half equals the right half, it's just:
            --   n × (10^k + 1)
            -- where n is any k-digit number.
            -- this works because: n × 10^k shifts n left by k digits, 
            -- then adding n repeats it. example: 12 × (10^2 + 1) = 12 × 101 = 1212
            --
            -- examples:
            --   - 2 digits: n × 11 (n=1..9) → 11, 22, 33, ..., 99
            --   - 4 digits: n × 101 (n=10..99) → 1010, 1111, 1212, ..., 9999
            --   - 6 digits: n × 1001 (n=100..999) → 100100, 101101, ..., 999999
            --
            -- so we figure out which digit counts could produce numbers in our range,
            -- then generate all candidates of that form and check if they're in range.
            -- way faster than checking millions of numbers one by one! (thank you lua for being so slow)

            local min_digits = math.floor(math.log10(s)) + 1  -- minimum digits needed for s
            local max_digits = math.floor(math.log10(e)) + 1  -- maximum digits needed for e
            
            for d = min_digits, max_digits do
                if d % 2 == 0 then
                    local k = d / 2
                    local multiplier = math.pow(10, k) + 1  -- e.g., for k=2: 10^2 + 1 = 101
                    
                    local min_n = math.pow(10, k - 1)  -- smallest k-digit number (e.g., k=2: 10)
                    local max_n = math.pow(10, k) - 1  -- largest k-digit number (e.g., k=2: 99)
                    
                    -- generate all numbers of this form
                    for n = min_n, max_n do
                        local candidate = n * multiplier  -- e.g., n=12, multiplier=101: 12*101 = 1212
                        
                        -- only check if it's in our range
                        if candidate >= s and candidate <= e then
                            table.insert(numbers, candidate)
                        elseif candidate > e then
                            break
                        end
                    end
                end
            end
        end
    end
end

local total = 0
for _, number in ipairs(numbers) do
    total = total + number
end

print(total)
local time_end = os.clock()
print("Time: " .. (time_end - time_start) * 1000 .. " ms") -- milliseconds because apparently lua is very slow