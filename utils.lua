local M = {}

-- Function to check if a file exists
-- path: The full path to the file to check
function M.file_exists(path)
  -- Try to open the file in read mode
  local file, err = io.open(path, "r")
  if file then
    -- If successful, close the file and return true
    file:close()
    return true
  else
    -- If io.open returns nil, the file does not exist or cannot be accessed
    -- err might contain an error message, but we only need to know it failed
    return false
  end
end

return M
