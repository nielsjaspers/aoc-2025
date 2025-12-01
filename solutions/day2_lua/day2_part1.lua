local time_start = os.clock()
local file = io.open("data/day2/day2.test", "r")
if file then
    print("See you tomorrow!")
else
    print("Failed to open file")
end
local time_end = os.clock()
print("Time: " .. (time_end - time_start) * 1000 .. " ms") -- milliseconds because apparently lua is very slow