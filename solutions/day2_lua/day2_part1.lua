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
            
            -- print(s, e)
            for i = s, e do
                if string.len(i) % 2 == 0 then
                    -- print(i)
                    local len = string.len(i)
                    local mid = math.floor(len / 2)

                    local left = string.sub(i, 1, mid)
                    local right = string.sub(i, mid + 1)

                    if left == right then
                        table.insert(numbers, tonumber(i))
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