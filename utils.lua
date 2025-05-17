local M = {}

-- Helper function to check if a file exists
function M.file_exists(name)
    local f = io.open(name, "r")
    if f then
        f:close()
        return true
    else
        return false
    end
end

return M
