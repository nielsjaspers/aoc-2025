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
local seen = {}

if file then
    local line = file:read("*line")
    if line then
        local ranges = split(line, ",")
        for _, range in ipairs(ranges) do
            local dash_pos = string.find(range, "-")
            local s = tonumber(string.sub(range, 1, dash_pos - 1))
            local e = tonumber(string.sub(range, dash_pos + 1))
            
            -- instead of checking every number in the range,
            -- we generate only numbers that match a repeating pattern.
            --
            -- a number matches if it can be written as the same chunk repeated 2+ times.
            -- examples:
            --   - 11: chunk "1" repeated 2 times
            --   - 111: chunk "1" repeated 3 times
            --   - 1010: chunk "10" repeated 2 times
            --   - 565656: chunk "56" repeated 3 times
            --   - 824824824: chunk "824" repeated 3 times
            --
            -- algorithm:
            --
            -- 1. figure out which digit counts could appear in the range [s, e].
            --   example: range 95-115 contains 2-digit numbers (95-99) and 3-digit numbers (100-115)
            --   so we check d = 2 and d = 3
            --
            -- 2. for each digit count d, find all ways to split it into repeating chunks.
            --   a chunk size (k) is valid if:
            --     - k divides d evenly (no remainder)
            --     - d/k >= 2 (need at least 2 repetitions)
            --   
            --   example for d=6:
            --     - k=1: 6/1 = 6 repetitions (pattern "1" → 111111)
            --     - k=2: 6/2 = 3 repetitions (pattern "10" → 101010)
            --     - k=3: 6/3 = 2 repetitions (pattern "100" → 100100)
            --     - k=4: 6/4 = 1.5 repetitions (doesn't divide evenly)
            --
            -- 3. for each valid chunk size k, generate all possible k-digit patterns.
            --   example for k=2: generate all 2-digit numbers from 10 to 99
            --   these are the "chunks" we'll repeat (like "10", "11", "12", ..., "99")
            --
            -- 4. for each pattern p, use the formula to create the full repeating number.
            --   formula: p × (10^d - 1) / (10^k - 1)
            --   
            --   example: d=6, k=2, p=56
            --     - multiplier = (10^6 - 1) / (10^2 - 1) = 999999 / 99 = 10101
            --     - result = 56 × 10101 = 565656
            --   
            --   why this works: multiplying by 10101 repeats "56" three times: e.g.
            --     56 × 10101 = 56 × (10000 + 100 + 1) = 560000 + 5600 + 56 = 565656
            --
            -- 5. check if the generated number is in range [s, e] and not already added.
            --   if it's in range and we haven't seen it before, add it to our list.
            --
            -- example: for 6-digit numbers with chunk size 2 (repeat 3 times):
            --   - k=2, d=6, so multiplier = (10^6 - 1) / (10^2 - 1) = 999999 / 99 = 10101
            --   - Pattern p=56: 56 × 10101 = 565656
            --   - Pattern p=10: 10 × 10101 = 101010 
            --
            -- this way we only generate numbers that match the pattern, instead of
            -- checking millions of numbers one by one.

            local min_digits = math.floor(math.log10(s)) + 1
            local max_digits = math.floor(math.log10(e)) + 1
            
            for d = min_digits, max_digits do
                -- try all possible chunk sizes k that divide d evenly
                for k = 1, math.floor(d / 2) do
                    if d % k == 0 then
                        local repetitions = d / k
                        if repetitions >= 2 then
                            -- calculate multiplier: (10^d - 1) / (10^k - 1)
                            -- this repeats a k-digit pattern (d/k) times
                            local multiplier = (math.pow(10, d) - 1) / (math.pow(10, k) - 1)
                            
                            -- generate all k-digit patterns
                            local min_p = math.pow(10, k - 1)
                            local max_p = math.pow(10, k) - 1
                            
                            -- set start and end of pattern to be in range [s, e] to avoid generating numbers that are out of range
                            local start_p = math.max(min_p, math.ceil(s / multiplier))
                            local end_p = math.min(max_p, math.floor(e / multiplier))
                            
                            for p = start_p, end_p do
                                local candidate = p * multiplier
                                if not seen[candidate] then
                                    seen[candidate] = true
                                    table.insert(numbers, candidate)
                                end
                            end
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
print("Time: " .. (time_end - time_start) * 1000 .. " ms")