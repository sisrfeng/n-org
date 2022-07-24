module.config.public = {
    -- Which icon preset to use
    -- Go to [imports](#imports) to see which ones are currently defined
    -- E.g `core.norg.concealer.preset_diamond` will be `preset = "diamond"`
    icon_preset = "basic",

    -- Configuration for icons: their looks and behaviours are contained here
    icons = {
        todo = {
            enabled = true,

            done = {
                enabled = true,
                icon = "",
                highlight = "NeorgTodoItemDoneMark",
                query = "(todo_item_done) @icon",
                extract = function()
                    return 1
                end,
            },

            pending = {
                enabled = true,
                icon = "",
                highlight = "NeorgTodoItemPendingMark",
                query = "(todo_item_pending) @icon",
                extract = function()
                    return 1
                end,
            },

            undone = {
                enabled = true,
                icon = "×",
                highlight = "NeorgTodoItemUndoneMark",
                query = "(todo_item_undone) @icon",
                extract = function()
                    return 1
                end,
            },

            uncertain = {
                enabled = true,
                icon = "",
                highlight = "NeorgTodoItemUncertainMark",
                query = "(todo_item_uncertain) @icon",
                extract = function()
                    return 1
                end,
            },

            on_hold = {
                enabled = true,
                icon = "",
                highlight = "NeorgTodoItemOnHoldMark",
                query = "(todo_item_on_hold) @icon",
                extract = function()
                    return 1
                end,
            },

            cancelled = {
                enabled = true,
                icon = "",
                highlight = "NeorgTodoItemCancelledMark",
                query = "(todo_item_cancelled) @icon",
                extract = function()
                    return 1
                end,
            },

            recurring = {
                enabled = true,
                icon = "↺",
                highlight = "NeorgTodoItemRecurringMark",
                query = "(todo_item_recurring) @icon",
                extract = function()
                    return 1
                end,
            },

            urgent = {
                enabled = true,
                icon = "⚠",
                highlight = "NeorgTodoItemUrgentMark",
                query = "(todo_item_urgent) @icon",
                extract = function()
                    return 1
                end,
            },
        },

        list = {
            enabled = true,

            level_1 = {
                enabled = true,
                icon = "•",
                highlight = "NeorgUnorderedList1",
                query = "(unordered_list1_prefix) @icon",
            },

            level_2 = {
                enabled = true,
                icon = " •",
                highlight = "NeorgUnorderedList2",
                query = "(unordered_list2_prefix) @icon",
            },

            level_3 = {
                enabled = true,
                icon = "  •",
                highlight = "NeorgUnorderedList3",
                query = "(unordered_list3_prefix) @icon",
            },

            level_4 = {
                enabled = true,
                icon = "   •",
                highlight = "NeorgUnorderedList4",
                query = "(unordered_list4_prefix) @icon",
            },

            level_5 = {
                enabled = true,
                icon = "    •",
                highlight = "NeorgUnorderedList5",
                query = "(unordered_list5_prefix) @icon",
            },

            level_6 = {
                enabled = true,
                icon = "     •",
                highlight = "NeorgUnorderedList6",
                query = "(unordered_list6_prefix) @icon",
            },
        },

        link = {
            enabled = true,
            level_1 = {
                enabled = true,
                icon = " ",
                highlight = "NeorgUnorderedLink1",
                query = "(unordered_link1_prefix) @icon",
            },
            level_2 = {
                enabled = true,
                icon = "  ",
                highlight = "NeorgUnorderedLink2",
                query = "(unordered_link2_prefix) @icon",
            },
            level_3 = {
                enabled = true,
                icon = "   ",
                highlight = "NeorgUnorderedLink3",
                query = "(unordered_link3_prefix) @icon",
            },
            level_4 = {
                enabled = true,
                icon = "    ",
                highlight = "NeorgUnorderedLink4",
                query = "(unordered_link4_prefix) @icon",
            },
            level_5 = {
                enabled = true,
                icon = "     ",
                highlight = "NeorgUnorderedLink5",
                query = "(unordered_link5_prefix) @icon",
            },
            level_6 = {
                enabled = true,
                icon = "      ",
                highlight = "NeorgUnorderedLink6",
                query = "(unordered_link6_prefix) @icon",
            },
        },

        ordered = {
            enabled = require("neorg.external.helpers").is_minimum_version(0, 6, 0),

            level_1 = {
                enabled = true,
                icon = module.public.concealing.ordered.punctuation.unicode_dot(
                    module.public.concealing.ordered.enumerator.numeric
                ),
                highlight = "NeorgOrderedList1",
                query = "(ordered_list1_prefix) @icon",
                render = function(self, _, node)
                    local count = module.public.concealing.ordered.get_index(node, "ordered_list1")
                    return {
                        { self.icon(count), self.highlight },
                    }
                end,
            },

            level_2 = {
                enabled = true,
                icon = module.public.concealing.ordered.enumerator.latin_uppercase,
                highlight = "NeorgOrderedList2",
                query = "(ordered_list2_prefix) @icon",
                render = function(self, _, node)
                    local count = module.public.concealing.ordered.get_index(node, "ordered_list2")
                    return {
                        { " " .. self.icon(count), self.highlight },
                    }
                end,
            },

            level_3 = {
                enabled = true,
                icon = module.public.concealing.ordered.enumerator.latin_lowercase,
                highlight = "NeorgOrderedList3",
                query = "(ordered_list3_prefix) @icon",
                render = function(self, _, node)
                    local count = module.public.concealing.ordered.get_index(node, "ordered_list3")
                    return {
                        { "  " .. self.icon(count), self.highlight },
                    }
                end,
            },

            level_4 = {
                enabled = true,
                icon = module.public.concealing.ordered.punctuation.unicode_double_parenthesis(
                    module.public.concealing.ordered.enumerator.numeric
                ),
                highlight = "NeorgOrderedList4",
                query = "(ordered_list4_prefix) @icon",
                render = function(self, _, node)
                    local count = module.public.concealing.ordered.get_index(node, "ordered_list4")
                    return {
                        { "   " .. self.icon(count), self.highlight },
                    }
                end,
            },

            level_5 = {
                enabled = true,
                icon = module.public.concealing.ordered.enumerator.latin_uppercase,
                highlight = "NeorgOrderedList5",
                query = "(ordered_list5_prefix) @icon",
                render = function(self, _, node)
                    local count = module.public.concealing.ordered.get_index(node, "ordered_list5")
                    return {
                        { "    " .. self.icon(count), self.highlight },
                    }
                end,
            },

            level_6 = {
                enabled = true,
                icon = module.public.concealing.ordered.punctuation.unicode_double_parenthesis(
                    module.public.concealing.ordered.enumerator.latin_lowercase
                ),
                highlight = "NeorgOrderedList6",
                query = "(ordered_list6_prefix) @icon",
                render = function(self, _, node)
                    local count = module.public.concealing.ordered.get_index(node, "ordered_list6")
                    return {
                        { "     " .. self.icon(count), self.highlight },
                    }
                end,
            },
        },

        ordered_link = {
            enabled = true,
            level_1 = {
                enabled = true,
                icon = module.public.concealing.ordered.punctuation.unicode_circle(
                    module.public.concealing.ordered.enumerator.numeric
                ),
                highlight = "NeorgOrderedLink1",
                query = "(ordered_link1_prefix) @icon",
                render = function(self, _, node)
                    local count = module.public.concealing.ordered.get_index(node, "ordered_link1")
                    return {
                        { " " .. self.icon(count), self.highlight },
                    }
                end,
            },
            level_2 = {
                enabled = true,
                icon = module.public.concealing.ordered.punctuation.unicode_circle(
                    module.public.concealing.ordered.enumerator.latin_uppercase
                ),
                highlight = "NeorgOrderedLink2",
                query = "(ordered_link2_prefix) @icon",
                render = function(self, _, node)
                    local count = module.public.concealing.ordered.get_index(node, "ordered_link2")
                    return {
                        { "  " .. self.icon(count), self.highlight },
                    }
                end,
            },
            level_3 = {
                enabled = true,
                icon = module.public.concealing.ordered.punctuation.unicode_circle(
                    module.public.concealing.ordered.enumerator.latin_lowercase
                ),
                highlight = "NeorgOrderedLink3",
                query = "(ordered_link3_prefix) @icon",
                render = function(self, _, node)
                    local count = module.public.concealing.ordered.get_index(node, "ordered_link3")
                    return {
                        { "   " .. self.icon(count), self.highlight },
                    }
                end,
            },
            level_4 = {
                enabled = true,
                icon = module.public.concealing.ordered.punctuation.unicode_circle(
                    module.public.concealing.ordered.enumerator.numeric
                ),
                highlight = "NeorgOrderedLink4",
                query = "(ordered_link4_prefix) @icon",
                render = function(self, _, node)
                    local count = module.public.concealing.ordered.get_index(node, "ordered_link4")
                    return {
                        { "    " .. self.icon(count), self.highlight },
                    }
                end,
            },
            level_5 = {
                enabled = true,
                icon = module.public.concealing.ordered.punctuation.unicode_circle(
                    module.public.concealing.ordered.enumerator.latin_uppercase
                ),
                highlight = "NeorgOrderedLink5",
                query = "(ordered_link5_prefix) @icon",
                render = function(self, _, node)
                    local count = module.public.concealing.ordered.get_index(node, "ordered_link5")
                    return {
                        { "     " .. self.icon(count), self.highlight },
                    }
                end,
            },
            level_6 = {
                enabled = true,
                icon = module.public.concealing.ordered.punctuation.unicode_circle(
                    module.public.concealing.ordered.enumerator.latin_lowercase
                ),
                highlight = "NeorgOrderedLink6",
                query = "(ordered_link6_prefix) @icon",
                render = function(self, _, node)
                    local count = module.public.concealing.ordered.get_index(node, "ordered_link6")
                    return {
                        { "      " .. self.icon(count), self.highlight },
                    }
                end,
            },
        },

        quote = {
            enabled = true,

            level_1 = {
                enabled = true,
                icon = "│",
                highlight = "NeorgQuote1",
                query = "(quote1_prefix) @icon",
            },

            level_2 = {
                enabled = true,
                icon = "│",
                highlight = "NeorgQuote2",
                query = "(quote2_prefix) @icon",
                render = function(self)
                    return {
                        { self.icon, module.config.public.icons.quote.level_1.highlight },
                        { self.icon, self.highlight },
                    }
                end,
            },

            level_3 = {
                enabled = true,
                icon = "│",
                highlight = "NeorgQuote3",
                query = "(quote3_prefix) @icon",
                render = function(self)
                    return {
                        { self.icon, module.config.public.icons.quote.level_1.highlight },
                        { self.icon, module.config.public.icons.quote.level_2.highlight },
                        { self.icon, self.highlight },
                    }
                end,
            },

            level_4 = {
                enabled = true,
                icon = "│",
                highlight = "NeorgQuote4",
                query = "(quote4_prefix) @icon",
                render = function(self)
                    return {
                        { self.icon, module.config.public.icons.quote.level_1.highlight },
                        { self.icon, module.config.public.icons.quote.level_2.highlight },
                        { self.icon, module.config.public.icons.quote.level_3.highlight },
                        { self.icon, self.highlight },
                    }
                end,
            },

            level_5 = {
                enabled = true,
                icon = "│",
                highlight = "NeorgQuote5",
                query = "(quote5_prefix) @icon",
                render = function(self)
                    return {
                        { self.icon, module.config.public.icons.quote.level_1.highlight },
                        { self.icon, module.config.public.icons.quote.level_2.highlight },
                        { self.icon, module.config.public.icons.quote.level_3.highlight },
                        { self.icon, module.config.public.icons.quote.level_4.highlight },
                        { self.icon, self.highlight },
                    }
                end,
            },

            level_6 = {
                enabled = true,
                icon = "│",
                highlight = "NeorgQuote6",
                query = "(quote6_prefix) @icon",
                render = function(self)
                    return {
                        { self.icon, module.config.public.icons.quote.level_1.highlight },
                        { self.icon, module.config.public.icons.quote.level_2.highlight },
                        { self.icon, module.config.public.icons.quote.level_3.highlight },
                        { self.icon, module.config.public.icons.quote.level_4.highlight },
                        { self.icon, module.config.public.icons.quote.level_5.highlight },
                        { self.icon, self.highlight },
                    }
                end,
            },
        },

        heading = {
            enabled = true,

            level_1 = {
                enabled = true,
                icon = "◉",
                highlight = "NeorgHeading1",
                query = "[ (heading1_prefix) (link_target_heading1) @no-conceal ] @icon",
            },

            level_2 = {
                enabled = true,
                icon = " ◎",
                highlight = "NeorgHeading2",
                query = "[ (heading2_prefix) (link_target_heading2) @no-conceal ] @icon",
            },

            level_3 = {
                enabled = true,
                icon = "  ○",
                highlight = "NeorgHeading3",
                query = "[ (heading3_prefix) (link_target_heading3) @no-conceal ] @icon",
            },

            level_4 = {
                enabled = true,
                icon = "   ✺",
                highlight = "NeorgHeading4",
                query = "[ (heading4_prefix) (link_target_heading4) @no-conceal ] @icon",
            },

            level_5 = {
                enabled = true,
                icon = "    ▶",
                highlight = "NeorgHeading5",
                query = "[ (heading5_prefix) (link_target_heading5) @no-conceal ] @icon",
            },

            level_6 = {
                enabled = true,
                icon = "     ⤷",
                highlight = "NeorgHeading6",
                query = "[ (heading6_prefix) (link_target_heading6) @no-conceal ] @icon",
                render = function(self, text)
                    return {
                        {
                            string.rep(" ", text:len() - string.len("******") - string.len(" ")) .. self.icon,
                            self.highlight,
                        },
                    }
                end,
            },
        },

        marker = {
            enabled = true,
            icon = "",
            highlight = "NeorgMarker",
            query = "[ (marker_prefix) (link_target_marker) @no-conceal ] @icon",
        },

        definition = {
            enabled = true,

            single = {
                enabled = true,
                icon = "≡",
                highlight = "NeorgDefinition",
                query = "[ (single_definition_prefix) (link_target_definition) @no-conceal ] @icon",
            },
            multi_prefix = {
                enabled = true,
                icon = "⋙ ",
                highlight = "NeorgDefinition",
                query = "(multi_definition_prefix) @icon",
            },
            multi_suffix = {
                enabled = true,
                icon = "⋘ ",
                highlight = "NeorgDefinitionEnd",
                query = "(multi_definition_suffix) @icon",
            },
        },

        footnote = {
            enabled = true,

            single = {
                enabled = true,
                icon = "⁎",
                highlight = "NeorgFootnote",
                query = "[ (single_footnote_prefix) (link_target_footnote) @no-conceal ] @icon",
            },
            multi_prefix = {
                enabled = true,
                icon = "⁑ ",
                highlight = "NeorgFootnote",
                query = "(multi_footnote_prefix) @icon",
            },
            multi_suffix = {
                enabled = true,
                icon = "⁑ ",
                highlight = "NeorgFootnoteEnd",
                query = "(multi_footnote_suffix) @icon",
            },
        },

        delimiter = {
            enabled = true,

            weak = {
                enabled = true,
                icon = "⟨",
                highlight = "NeorgWeakParagraphDelimiter",
                query = "(weak_paragraph_delimiter) @icon",
                render = function(self, text)
                    return {
                        { string.rep(self.icon, text:len()), self.highlight },
                    }
                end,
            },

            strong = {
                enabled = true,
                icon = "⟪",
                highlight = "NeorgStrongParagraphDelimiter",
                query = "(strong_paragraph_delimiter) @icon",
                render = function(self, text)
                    return {
                        { string.rep(self.icon, text:len()), self.highlight },
                    }
                end,
            },

            horizontal_line = {
                enabled = true,
                icon = "─",
                highlight = "NeorgHorizontalLine",
                query = "(horizontal_line) @icon",
                render = function(self, _, node)
                    -- Get the length of the Neovim window (used to render to the edge of the screen)
                    local resulting_length = vim.api.nvim_win_get_width(0)

                    -- If we are running at least 0.6 (which has the prev_sibling() function) then
                    if require("neorg.external.helpers").is_minimum_version(0, 6, 0) then
                        -- Grab the sibling before our current node in order to later
                        -- determine how much space it occupies in the buffer vertically
                        local prev_sibling = node:prev_sibling()
                        local double_prev_sibling = prev_sibling:prev_sibling()
                        local ts = module.required["core.integrations.treesitter"].get_ts_utils()

                        if prev_sibling then
                            -- Get the text of the previous sibling and store its longest line width-wise
                            local text = ts.get_node_text(prev_sibling)
                            local longest = 3

                            if
                                prev_sibling:parent()
                                and double_prev_sibling
                                and double_prev_sibling:type() == "marker_prefix"
                            then
                                local range_of_prefix =
                                    module.required["core.integrations.treesitter"].get_node_range(double_prev_sibling)
                                local range_of_title =
                                    module.required["core.integrations.treesitter"].get_node_range(prev_sibling)
                                resulting_length = (range_of_prefix.column_end - range_of_prefix.column_start)
                                    + (range_of_title.column_end - range_of_title.column_start)
                            else
                                -- Go through each line and remove its surrounding whitespace,
                                -- we do this because some inconsistencies tend to occur with
                                -- the way whitespace is handled.
                                for _, line in ipairs(text) do
                                    line = vim.trim(line)

                                    -- If the line even has any "normal" characters
                                    -- and its length is a new record then update the
                                    -- `longest` variable
                                    if line:match("%w") and line:len() > longest then
                                        longest = line:len()
                                    end
                                end
                            end

                            -- If we've set a longest value then override the resulting length
                            -- with that longest value (to make it render only up until that point)
                            if longest > 0 then
                                resulting_length = longest
                            end
                        end
                    end

                    return {
                        {
                            string.rep(self.icon, resulting_length),
                            self.highlight,
                        },
                    }
                end,
            },
        },

        markup = {
            enabled = true,

            spoiler = {
                enabled = true,
                icon = "•",
                highlight = "NeorgMarkupSpoiler",
                query = '(spoiler ("_open") _ @icon ("_close"))',
                render = function(self, text)
                    return { { string.rep(self.icon, text:len()), self.highlight } }
                end,
            },
        },
    },

    -- If you want to dim code blocks
    dim_code_blocks = {
        enabled = true,
        -- If true will only dim the content of the code block,
        -- not the code block itself.
        content_only = true,

        -- Will adapt based on the `conceallevel` option.
        -- If `conceallevel` > 0, then only the content will be dimmed,
        -- else the whole code block will be dimmed.
        adaptive = true,

        -- If `true` will conceal the `@code` and `@end` portion of the code
        -- block.
        conceal = true,
    },

    folds = true,

    completion_level = {
        enabled = true,

        queries = vim.tbl_deep_extend(
            "keep",
            {},
            (function()
                local result = {}

                for i = 1, 6 do
                    result["heading" .. i] = {
                        text = {
                            "(",
                            { "<done>", "TSField" },
                            " of ",
                            { "<total>", "NeorgTodoItem1Done" },
                            ") [<percentage>% complete]",
                        },

                        highlight = "DiagnosticVirtualTextHint",
                    }
                end

                return result
            end)()
            --[[ (function()
                local result = {}

                for i = 1, 6 do
                    result["todo_item" .. i] = {
                        text = "[<done>/<total>]",
                        highlight = "DiagnosticVirtualTextHint",
                    }
                end

                return result
            end)() ]]
        ),
    },

    performance = {
        increment = 1250,
        timeout = 0,
        interval = 500,
        max_debounce = 5,
    },
}

module.load = function()
    if not module.config.private["icon_preset_" .. module.config.public.icon_preset] then
        log.error(
            string.format(
                "Unable to load icon preset '%s' - such a preset does not exist",
                module.config.public.icon_preset
            )
        )
        return
    end

    module.config.public.icons = vim.tbl_deep_extend(
        "force",
        module.config.public.icons,
        module.config.private["icon_preset_" .. module.config.public.icon_preset] or {},
        module.config.custom
    )

    --- Queries all icons that have their `enable = true` flags set
    ---@param tbl table #The table to parse
    ---@param parent_icon string #Is used to pass icons from parents down to their table children to handle inheritance.
    ---@param rec_name string #Should not be set manually. Is used for Neorg to have information about all other previous recursions
    local function get_enabled_icons(tbl, parent_icon, rec_name)
        rec_name = rec_name or ""

        -- Create a result that we will return at the end of the function
        local result = {}

        -- If the current table isn't enabled then don't parser any further - simply return the empty result
        if vim.tbl_isempty(tbl) or (tbl.enabled ~= nil and tbl.enabled == false) then
            return result
        end

        -- Go through every icon
        for name, icons in pairs(tbl) do
            -- If we're dealing with a table (which we should be) and if the current icon set is enabled then
            if type(icons) == "table" and icons.enabled then
                -- If we have defined a query value then add that icon to the result
                if icons.query then
                    result[rec_name .. name] = icons

                    if icons.icon == nil then
                        result[rec_name .. name].icon = parent_icon
                    end
                else
                    -- If we don't have an icon variable then we need to descend further down the lua table.
                    -- To do this we recursively call this very function and merge the results into the result table
                    result =
                        vim.tbl_deep_extend("force", result, get_enabled_icons(icons, parent_icon, rec_name .. name))
                end
            end
        end

        return result
    end

    -- Set the module.private.icons variable to the values of the enabled icons
    module.private.icons = vim.tbl_values(get_enabled_icons(module.config.public.icons))

    -- Enable the required autocommands (these will be used to determine when to update conceals in the buffer)
    module.required["core.autocommands"].enable_autocommand("BufEnter")
    module.required["core.autocommands"].enable_autocommand("InsertEnter")
    module.required["core.autocommands"].enable_autocommand("InsertLeave")
    module.required["core.autocommands"].enable_autocommand("VimLeavePre")

    neorg.modules.await("core.neorgcmd", function(neorgcmd)
        neorgcmd.add_commands_from_table({
            definitions = {
                ["toggle-concealer"] = {},
            },
            data = {
                ["toggle-concealer"] = {
                    name = "core.norg.concealer.toggle",
                    args = 0,
                },
            },
        })
    end)

    if neorg.utils.is_minimum_version(0, 7, 0) then
        vim.api.nvim_create_autocmd("OptionSet", {
            pattern = "conceallevel",
            callback = function()
                local current_buffer = vim.api.nvim_get_current_buf()
                local has_conceal = (tonumber(vim.v.option_new) > 0)

                module.public.trigger_icons(
                    current_buffer,
                    has_conceal,
                    module.private.icons,
                    module.private.icon_namespace
                )

                if module.config.public.dim_code_blocks.adaptive then
                    module.public.trigger_code_block_highlights(current_buffer, has_conceal)
                end
            end,
        })
    end
end

module.on_event = function(event)
    if event.type == "core.neorgcmd.events.core.norg.concealer.toggle" then
        module.public.toggle_concealer()
    end

    if not module.private.enabled then
        return
    end

    module.private.debounce_counters[event.cursor_position[1] + 1] = module.private.debounce_counters[event.cursor_position[1] + 1]
        or 0

    local function should_debounce()
        return module.private.debounce_counters[event.cursor_position[1] + 1]
            >= module.config.public.performance.max_debounce
    end

    local has_conceal = vim.api.nvim_win_is_valid(event.window)
            and (vim.api.nvim_win_get_option(event.window, "conceallevel") > 0)
        or false

    if event.type == "core.autocommands.events.bufenter" and event.content.norg then
        if module.config.public.folds then
            vim.api.nvim_win_set_option(event.window, "foldmethod", "expr")
            vim.api.nvim_win_set_option(event.window, "foldexpr", "nvim_treesitter#foldexpr()")
            vim.api.nvim_win_set_option(
                event.window,
                "foldtext",
                "v:lua.neorg.modules.get_module('core.norg.concealer').foldtext()"
            )
        end

        local buf = event.buffer
        local line_count = vim.api.nvim_buf_line_count(buf)

        vim.api.nvim_buf_clear_namespace(buf, module.private.icon_namespace, 0, -1)
        vim.api.nvim_buf_clear_namespace(buf, module.private.code_block_namespace, 0, -1)
        vim.api.nvim_buf_clear_namespace(buf, module.private.completion_level_namespace, 0, -1)

        if line_count < module.config.public.performance.increment then
            module.public.trigger_icons(buf, has_conceal, module.private.icons, module.private.icon_namespace)
            module.public.trigger_code_block_highlights(buf, has_conceal)
            module.public.completion_levels.trigger_completion_levels(buf)
        else
            -- This bit of code gets triggered if the line count of the file is bigger than one increment level
            -- provided by the user.
            -- In this case, the concealer enters a block mode and splits up the file into chunks. It then goes through each
            -- chunk at a set interval and applies the conceals that way to reduce load and improve performance.

            -- This points to the current block the user's cursor is in
            local block_current =
                math.floor((line_count / module.config.public.performance.increment) % event.cursor_position[1])

            local function trigger_conceals_for_block(block)
                local line_begin = block == 0 and 0 or block * module.config.public.performance.increment - 1
                local line_end = math.min(
                    block * module.config.public.performance.increment + module.config.public.performance.increment - 1,
                    line_count
                )

                module.public.trigger_icons(
                    buf,
                    has_conceal,
                    module.private.icons,
                    module.private.icon_namespace,
                    line_begin,
                    line_end
                )

                module.public.trigger_code_block_highlights(buf, has_conceal, line_begin, line_end)
                module.public.completion_levels.trigger_completion_levels(buf, line_begin, line_end)
            end

            trigger_conceals_for_block(block_current)

            local block_bottom, block_top = block_current - 1, block_current + 1

            local timer = vim.loop.new_timer()

            timer:start(
                module.config.public.performance.timeout,
                module.config.public.performance.interval,
                vim.schedule_wrap(function()
                    local block_bottom_valid = block_bottom == 0
                        or (block_bottom * module.config.public.performance.increment - 1 >= 0)
                    local block_top_valid = block_top * module.config.public.performance.increment - 1 < line_count

                    if not block_bottom_valid and not block_top_valid then
                        timer:stop()
                        return
                    end

                    if block_bottom_valid then
                        trigger_conceals_for_block(block_bottom)
                        block_bottom = block_bottom - 1
                    end

                    if block_top_valid then
                        trigger_conceals_for_block(block_top)
                        block_top = block_top + 1
                    end
                end)
            )
        end

        module.private.attach_uid = module.private.attach_uid + 1
        local uid_upvalue = module.private.attach_uid

        vim.api.nvim_buf_attach(buf, false, {
            on_lines = function(_, cur_buf, _, start, _end)
                -- There are edge cases where the current buffer is not the same as the tracked buffer,
                -- which causes desyncs
                if buf ~= cur_buf or not module.private.enabled or uid_upvalue ~= module.private.attach_uid then
                    return true
                end

                if should_debounce() then
                    return
                end

                module.private.last_change.active = true

                local mode = vim.api.nvim_get_mode().mode

                if mode ~= "i" then
                    module.private.debounce_counters[event.cursor_position[1] + 1] = module.private.debounce_counters[event.cursor_position[1] + 1]
                        + 1

                    schedule(function()
                        has_conceal = vim.api.nvim_win_is_valid(event.window)
                                and (vim.api.nvim_win_get_option(event.window, "conceallevel") > 0)
                            or false
                        local new_line_count = vim.api.nvim_buf_line_count(buf)

                        -- Sometimes occurs with one-line undos
                        if start == _end then
                            _end = _end + 1
                        end

                        if new_line_count > line_count then
                            _end = _end + (new_line_count - line_count - 1)
                        end

                        line_count = new_line_count

                        module.public.trigger_icons(
                            buf,
                            has_conceal,
                            module.private.icons,
                            module.private.icon_namespace,
                            start,
                            _end
                        )

                        -- NOTE(vhyrro): It is simply not possible to perform incremental
                        -- updates here. Code blocks require more context than simply a few lines.
                        -- It's still incredibly fast despite this fact though.
                        module.public.trigger_code_block_highlights(buf, has_conceal)

                        module.public.completion_levels.trigger_completion_levels(buf, start, _end)

                        vim.schedule(function()
                            module.private.debounce_counters[event.cursor_position[1] + 1] = module.private.debounce_counters[event.cursor_position[1] + 1]
                                - 1
                        end)
                    end)
                else
                    schedule(neorg.lib.wrap(module.public.trigger_code_block_highlights, buf, has_conceal, start, _end))

                    if module.private.largest_change_start == -1 then
                        module.private.largest_change_start = start
                    end

                    if module.private.largest_change_end == -1 then
                        module.private.largest_change_end = _end
                    end

                    module.private.largest_change_start = start < module.private.largest_change_start and start
                        or module.private.largest_change_start
                    module.private.largest_change_end = _end > module.private.largest_change_end and _end
                        or module.private.largest_change_end
                end
            end,
        })
    elseif event.type == "core.autocommands.events.insertenter" then
        schedule(function()
            module.private.last_change = {
                active = false,
                line = event.cursor_position[1] - 1,
            }

            vim.api.nvim_buf_clear_namespace(
                event.buffer,
                module.private.icon_namespace,
                event.cursor_position[1] - 1,
                event.cursor_position[1]
            )

            vim.api.nvim_buf_clear_namespace(
                event.buffer,
                module.private.completion_level_namespace,
                event.cursor_position[1] - 1,
                event.cursor_position[1]
            )
        end)
    elseif event.type == "core.autocommands.events.insertleave" then
        if should_debounce() then
            return
        end

        schedule(function()
            if not module.private.last_change.active or module.private.largest_change_end == -1 then
                module.public.trigger_icons(
                    event.buffer,
                    has_conceal,
                    module.private.icons,
                    module.private.icon_namespace,
                    module.private.last_change.line,
                    module.private.last_change.line + 1
                )

                module.public.completion_levels.trigger_completion_levels_incremental(
                    event.buffer,
                    event.cursor_position[1] - 1
                )
            else
                module.public.trigger_icons(
                    event.buffer,
                    has_conceal,
                    module.private.icons,
                    module.private.icon_namespace,
                    module.private.largest_change_start,
                    module.private.largest_change_end
                )

                module.public.completion_levels.trigger_completion_levels_incremental(
                    event.buffer,
                    event.cursor_position[1] - 1
                )
            end

            module.private.largest_change_start, module.private.largest_change_end = -1, -1
        end)
    elseif event.type == "core.autocommands.events.vimleavepre" then
        module.private.disable_deferred_updates = true
    end
end

module.events.subscribed = {
    ["core.autocommands"] = {
        bufenter = true,
        insertenter = true,
        insertleave = true,
        vimleavepre = true,
    },

    ["core.neorgcmd"] = {
        ["core.norg.concealer.toggle"] = true,
    },
}

return module

