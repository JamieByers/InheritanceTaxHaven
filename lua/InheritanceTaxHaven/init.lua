print("ITH plugin loaded")

local M = {}

function M.getLines()
    local lines = {}

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
            for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
                table.insert(lines, line)
            end
        end
    end

    vim.print(lines)
end

vim.api.nvim_create_user_command("ITHGetLines", M.getLines, {})

