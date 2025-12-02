local time_start = os.clock()

-- precompute powers of 10 cache to avoid repeated math.pow() calls
-- optimizes repeated calls to math.pow(10, k)
local pow10_cache = {}
local function pow10(n)
    if not pow10_cache[n] then
        pow10_cache[n] = math.pow(10, n)
    end
    return pow10_cache[n]
end

local file = io.open("data/day2/day2.txt", "r")

local total = 0
local seen = {}

if file then
    local line = file:read("*line")
    if line then
        for s_str, e_str in line:gmatch("(%d+)-(%d+)") do
            local s = tonumber(s_str)  -- start number
            local e = tonumber(e_str)  -- end number
            
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
            --   if it's in range and we haven't seen it before, add it to our total.
            --
            -- example: for 6-digit numbers with chunk size 2 (repeat 3 times):
            --   - k=2, d=6, so multiplier = (10^6 - 1) / (10^2 - 1) = 999999 / 99 = 10101
            --   - Pattern p=56: 56 × 10101 = 565656
            --   - Pattern p=10: 10 × 10101 = 101010 
            --
            -- this way we only generate numbers that match the pattern, instead of
            -- checking millions of numbers one by one.

            -- use string length instead of math.log10() for digit counting
            -- this is faster for integer digit counting and avoids floating point operations
            local min_digits = #s_str  -- minimum digits needed for s
            local max_digits = #e_str  -- maximum digits needed for e
            
            for d = min_digits, max_digits do
                -- try all possible chunk sizes k that divide d evenly
                for k = 1, math.floor(d / 2) do
                    if d % k == 0 then
                        local repetitions = d / k
                        if repetitions >= 2 then
                            -- calculate multiplier: (10^d - 1) / (10^k - 1)
                            -- this repeats a k-digit pattern (d/k) times
                            local multiplier = (pow10(d) - 1) / (pow10(k) - 1)
                            
                            -- generate all k-digit patterns
                            local min_p = pow10(k - 1)
                            local max_p = pow10(k) - 1
                            
                            -- compute tight bounds: only generate p values that produce candidates in range [s, e]
                            -- since candidate = p × multiplier, we need s ≤ p × multiplier ≤ e
                            -- this gives us: s/multiplier ≤ p ≤ e/multiplier
                            -- we clamp this to the valid p range [min_p, max_p] to avoid generating out-of-range numbers
                            local start_p = math.max(min_p, math.ceil(s / multiplier))
                            local end_p = math.min(max_p, math.floor(e / multiplier))
                            
                            -- sum directly and track duplicates with seen table
                            -- same number can be generated by multiple patterns (e.g., 111111 by k=1, k=2, or k=3)
                            for p = start_p, end_p do
                                local candidate = p * multiplier
                                if not seen[candidate] then
                                    seen[candidate] = true
                                    total = total + candidate
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    file:close()
end

print(total)
local time_end = os.clock()
print("Time: " .. (time_end - time_start) * 1000 .. " ms")