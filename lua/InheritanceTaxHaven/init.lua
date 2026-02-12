print("ITH plugin loaded")

local M = {}

M.config = {
    default_filetypes = {
        "python",
        "lua",
        "c",
        "cpp",
        "java",
        "javascript",
        "typescript",
        "cs",
        "objc",
        "swift",
        "rust",
        "go",
        "kotlin",
        "scala",
        "php",
        "perl",
        "d",
        "vala",
        "dart",
        "haxe",
        "zig",
        "processing",
        "groovy",
        "fsharp",
        "julia",
        "vhdl",
        "verilog",
        "pascal",
        "asm",
        "nim",
        "ada",
        "fortran",
        "ocaml",
        "coq",
        "elixir",
        "crystal",
        "pony",
        "racket",
        "scheme",
        "bash",
        "fish",
        "zsh",
    },
    filetypes = {},

}

function M.GetRoot()
    local root = vim.fs.root(0, {
        ".git",
    })

    if not root then
       root = vim.loop.cwd()
    end

    vim.print("Root: ", root)
   return root
end


function M.IsDir(path)
    local stat = vim.loop.fs_stat(path)
    return stat and stat.type == "directory"
end

local function contains(l, v)
   for _, el in ipairs(l) do
        if el:find(v, 1, true) then
            return true
        end
    end

    return false
end


local function filterFiles(path)
    local filetype = vim.filetype.match({ filename = path })
    if filetype and (contains(M.config.default_filetypes, filetype) or contains(M.config.filetypes, filetype)) then
        return true
    end

    return false
end

function M.TraverseFiles(root, paths)
    local dir = vim.fs.dir(root)

    for path in dir do
        local full_path = root .. "/" ..  path
        if M.IsDir(full_path) and path ~= ".git" then
            M.TraverseFiles(full_path, paths)
        else
            if filterFiles(path) then
                table.insert(paths, full_path)
            end
        end
    end

    return paths
end

local function readFiles(paths)
    local lines = {}
    for i, path in ipairs(paths) do
        local file = io.lines(path)
        local file_lines = {}
        if file then
            for line in file do
                table.insert(file_lines, line)
            end
        end

        table.insert(lines, {
                fileName = path,
                fileNo = i,
                lines = file_lines
        })

    end


    return lines
end

function M.GetFiles()
    local root = M.GetRoot()
    local paths = M.TraverseFiles(root, {})
    local lines = readFiles(paths)

    vim.print("Lines: ", lines)
    return lines
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
end

vim.api.nvim_create_user_command("ITHGetLines", M.GetLines, {})
vim.api.nvim_create_user_command("ITHGetRoot", M.GetRoot, {})
vim.api.nvim_create_user_command("ITHGetFiles", M.GetFiles, {})


function M.Reload()
    package.loaded["InheritanceTaxHaven"] = nil
    require("InheritanceTaxHaven")
    print("ITH reloaded")
end

vim.api.nvim_create_user_command("ITHReload", M.Reload, {})


vim.api.nvim_create_user_command("ITHD", function()
    M.Reload()
    M.GetFiles()
end, {})



return M
