-- calc.lua - run: lua calc.lua
io.write("Enter: a op b  (op = + - * /, q to quit)\n")
local function trim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end

while true do
    io.write("> ")
    io.flush()
    local line = io.read("l")
    if not line then break end
    line = trim(line)
    if line == "" then
        -- continue
    elseif line:lower() == "q" then
        break
    else
        local sa, op, sb = line:match("^(%S+)%s+(%S+)%s+(%S+)$")
        if not sa then
            print("Error: invalid input format.")
        else
            local a = tonumber(sa)
            local b = tonumber(sb)
            if not a or not b or a ~= a or b ~= b or a == math.huge or a == -math.huge or b == math.huge or b == -math.huge then
                print("Error: invalid number.")
            else
                local r
                local ok = true
                if op == "+" then r = a + b
                elseif op == "-" then r = a - b
                elseif op == "*" then r = a * b
                elseif op == "/" then
                    if b == 0 then print("Error: division by zero.") ok = false
                    else r = a / b end
                else
                    print("Error: unknown operator '" .. op .. "'.") ok = false
                end
                if ok then
                    if math.type and math.type(r) == "integer" then
                        print("= " .. r)
                    elseif r == math.floor(r) and math.abs(r) < 1e15 then
                        print(string.format("= %d", r))
                    else
                        print(string.format("= %.10g", r))
                    end
                end
            end
        end
    end
end