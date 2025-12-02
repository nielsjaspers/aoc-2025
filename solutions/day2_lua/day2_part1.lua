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

if file then
    local line = file:read("*line")
    if line then
        for s_str, e_str in line:gmatch("(%d+)-(%d+)") do
            local s = tonumber(s_str)  -- start number
            local e = tonumber(e_str)  -- end number
            
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
            -- then generate all candidates of that form that fall within the range.
            -- way faster than checking millions of numbers one by one! (thank you lua for being so slow)

            -- use string length instead of math.log10() for digit counting
            -- this is faster for integer digit counting and avoids floating point operations
            local min_digits = #s_str  -- minimum digits needed for s
            local max_digits = #e_str  -- maximum digits needed for e
            
            for d = min_digits, max_digits do
                if d % 2 == 0 then
                    local k = d / 2
                    local multiplier = pow10(k) + 1  -- e.g. for k=2: 10^2 + 1 = 101
                    
                    local min_n = pow10(k - 1)  -- smallest k-digit number (e.g. k=2: 10)
                    local max_n = pow10(k) - 1  -- largest k-digit number (e.g. k=2: 99)
                    
                    -- compute tight bounds: only generate n values that produce candidates in range [s, e]
                    -- since candidate = n × multiplier, we need s ≤ n × multiplier ≤ e
                    -- this gives us: s/multiplier ≤ n ≤ e/multiplier
                    -- we clamp this to the valid n range [min_n, max_n] to avoid generating out-of-range numbers
                    local start_n = math.max(min_n, math.ceil(s / multiplier))
                    local end_n = math.min(max_n, math.floor(e / multiplier))
                    
                    for n = start_n, end_n do
                        total = total + (n * multiplier)
                    end
                end
            end
        end
    end
    file:close()
end

print(total)
local time_end = os.clock()
print("Time: " .. (time_end - time_start) * 1000 .. " ms") -- milliseconds because apparently lua is very slow