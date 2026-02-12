print("ITH plugin loaded")

local M = {}

function M.GetRoot();
    local root = vim.fs.root(0, {
        ".git",
    })

    if not root then
       root = vim.loop.cwd()
    end

    vim.print("Root: ", root)
   return root
end

function M.GetFiles()
    local root = M.GetRoot()

    local dir = vim.fs.dir(root)
    vim.print(dir)


end



function M.GetLines()
    local buf_lines = {}

    for i, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
            local lines = {}
            for j, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
                table.insert(lines, {j, line})
            end
            table.insert(buf_lines, {i, lines})
        end
    end

    vim.json.encode(buf_lines)
    vim.print(vim.json.encode(buf_lines))
end

vim.api.nvim_create_user_command("ITHGetLines", M.GetLines, {})

