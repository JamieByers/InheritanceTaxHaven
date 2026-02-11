local M = {}

local function getLines()
    local lines = {}

    for buf, _ in pairs(vim.api.nvim_list_bufs()) do
         if vim.api.nvim_buf_is_loaded(buf) then
            for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
                table.insert(lines, line)
            end
        end
    end


    print(lines)

end
