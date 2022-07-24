-- File: Concealer
-- Title: Concealer Module for Neorg
-- Summary: Enhances the basic Neorg experience by using icons instead of text.

-- /home/wf/.local/share/nvim/PL/n-org/wiki/Concealer.md



require("neorg.modules.base")

local module = neorg.modules.create("core.norg.concealer")

--- Schedule a function if there is no debounce active
--or if deferred updates have been disabled
---@param func function #Any function to execute
local function schedule(func)
    vim.schedule(function()
        if
            module.private.disable_deferred_updates
            or (
                (module.private.debounce_counters[vim.api.nvim_win_get_cursor(0)[1] + 1] or 0)
                >= module.config.public.performance.max_debounce
            )
        then
            return
        end

        func()
    end)
end

local function add_to_counters_if_todo_node(node, results)
    if vim.startswith(node:type(), "todo_item") then
        local type_node = node:named_child(1)

        if type_node then
            local todo_item_type = type_node:type():sub(string.len("todo_item_") + 1)
            local resulting_todo_item = results[todo_item_type] or 0

            results[todo_item_type] = resulting_todo_item + 1
            results.total = results.total + (todo_item_type == "cancelled" and 0 or 1)
        end
    end
end

local function count_todo_nodes_under_node(root_node, results)
    add_to_counters_if_todo_node(root_node, results)
    for child_node in root_node:iter_children() do
        count_todo_nodes_under_node(child_node, results)
    end
end

module.setup = function()
    return {
        success = true,
        requires = {
            "core.autocommands",
            "core.integrations.treesitter",
        },
        imports = {
            "preset_basic",
            "preset_varied",
            "preset_diamond",
        },
    }
end

module.private = {
    icon_namespace             = vim.api.nvim_create_namespace("neorg-conceals")         ,
    code_block_namespace       = vim.api.nvim_create_namespace("neorg-code-blocks")      ,
    completion_level_namespace = vim.api.nvim_create_namespace("neorg-completion-level") ,
    icons                      = {}                                                      ,

    largest_change_start = -1 ,
    largest_change_end   = -1 ,

    last_change = {
        active = false ,
        line   = 0     ,
    },

    disable_deferred_updates = false ,
    debounce_counters        = {}    ,

    enabled    = true ,

    attach_uid = 0    ,
}


require("neorg.modules.core.norg.concealer.public")
require("neorg.modules.core.norg.concealer.module2")

