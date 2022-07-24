---@class core.norg.concealer
module.public = { 
    --- Triggers an icon set for the current buffer
    ---@param buf number          # The ID of the buffer to apply conceals in
    ---@param has_conceal boolean # Whether or not concealing is enabled
    ---@param icon_set table      # The icon set to use
    ---@param namespace number    # The extmark namespace to use when setting extmarks
    ---@param from? number        # The line number to start parsing from (used for incremental updates)
    ---@param to? number          #                    keep parsing to 
    trigger_icons = function(buf,
                             has_conceal,
                             icon_set,
                             namespace,
                             from,
                             to,
                            )
        -- Get old extmarks - this is done to reduce visual glitches;
            -- all old extmarks are stored,
            -- the new extmarks are applied on top of the old ones,
            -- then the old ones are deleted.
        local old_extmarks = module.public.get_old_extmarks(buf,
                                                            namespace,
                                                            from,
                                                            to and to - 1,
                                                           )

        -- Get the root node of the document
        -- (required to iterate over query captures)
        local document_root = module.required["core.integrations.treesitter"].get_document_root(buf)

        if not document_root then
            return
        end

        -- Loop through all icons that the user has enabled
        for _, icon_data in ipairs(icon_set) do
            schedule(function()
                if icon_data.query then
                    -- Attempt to parse the query provided by `icon_data.query`
                    -- A query must have at least one capture, e.g. "(test_node) @icon"
                    local query = vim.treesitter.parse_query("norg", icon_data.query)

                    -- This is a mapping of [id] = to_omit pairs, where `id` is a treesitter
                    -- node's id and `to_omit` is a boolean.
                    -- The reason we do this is because some nodes should not be iconified
                    -- if `conceallevel` > 2.
                    local nodes_to_omit = {}

                    -- Go through every found node and try to apply an icon to it
                    -- The reason `iter_prepared_matches` and other `nvim-treesitter` functions are used here is because
                    -- we also want to support special captures and predicates like `(#has-parent?)`
                    for id, node in query:iter_captures(document_root, buf, from or 0, to or -1) do
                        local capture = query.captures[id]
                        local rs, _, re = node:range()

                        -- If the node has a `no-conceal` capture name then omit it
                        -- when rendering icons.
                        if capture == "no-conceal" and has_conceal then
                            nodes_to_omit[node:id()] = true
                        end

                        if capture == "icon" and not nodes_to_omit[node:id()] then
                            if rs < (from or 0) or re > (to or math.huge) then
                                goto continue
                            end

                            -- Extract both the text and the range of the node
                            local text = module.required["core.integrations.treesitter"].get_node_text(node, buf)
                            local range = module.required["core.integrations.treesitter"].get_node_range(node)

                            -- Set the offset to 0 here. The offset is a special value that, well, offsets
                            -- the location of the icon column-wise
                            -- It's used in scenarios where the node spans more than what we want to iconify.
                            -- A prime example of this is the todo item, whose content looks like this: "[x]".
                            -- We obviously don't want to iconify the entire thing, this is why we will tell Neorg
                            -- to use an offset of 1 to start the icon at the "x"
                            local offset = 0

                            -- The extract function is used exactly to calculate this offset
                            -- If that function is present then run it and grab the return value
                            if icon_data.extract then
                                offset = icon_data.extract(text, node) or 0
                            end

                            -- Every icon can also implement a custom "render" function that can allow for things like multicoloured icons
                            -- This is primarily used in nested quotes
                            -- The "render" function must return a table of this structure: { { "text", "highlightgroup1" }, { "optionally more text", "higlightgroup2" } }
                            if not icon_data.render then
                                module.public._set_extmark(
                                    buf,
                                    icon_data.icon,
                                    icon_data.highlight,
                                    namespace,
                                    range.row_start,
                                    range.row_end,
                                    range.column_start + offset,
                                    range.column_end,
                                    false,
                                    "combine"
                                )
                            else
                                module.public._set_extmark(
                                    buf,
                                    icon_data:render(text, node),
                                    icon_data.highlight,
                                    namespace,
                                    range.row_start,
                                    range.row_end,
                                    range.column_start + offset,
                                    range.column_end,
                                    false,
                                    "combine"
                                )
                            end
                        end

                        ::continue::
                    end
                end
            end)
        end

        -- After we have applied every extmark we can remove the old ones
        schedule(function()
            neorg.lib.map(old_extmarks, function(_, id)
                vim.api.nvim_buf_del_extmark(buf, namespace, id)
            end)
        end)
    end,

    --- Dims code blocks in the buffer
    ---@param buf number #The buffer to apply the dimming in
    ---@param from? number #The line number to start parsing from (used for incremental updates)
    ---@param to? number #The line number to keep parsing until (used for incremental updates)
    trigger_code_block_highlights = function(buf, has_conceal, from, to)
        -- If the code block dimming is disabled, return right away.
        if not module.config.public.dim_code_blocks.enabled then
            return
        end

        -- Similarly to `trigger_icons()`, we get all old extmarks here, apply the new dims on top of the old ones,
        -- then delete the old extmarks to prevent flickering
        local old_extmarks = module.public.get_old_extmarks(buf, module.private.code_block_namespace, from, to)

        -- The next block of code will be responsible for dimming code blocks accordingly
        local tree = vim.treesitter.get_parser(buf, "norg"):parse()[1]

        -- If the tree is valid then attempt to perform the query
        if tree then
            -- Query all code blocks
            local ok, query = pcall(
                vim.treesitter.parse_query,
                "norg",
                [[(
                    (ranged_tag (tag_name) @_name) @tag
                    (#eq? @_name "code")
                )]]
            )

            -- If something went wrong then go bye bye
            if not ok or not query then
                return
            end

            -- Go through every found capture
            for id, node in query:iter_captures(tree:root(), buf, from or 0, to or -1) do
                schedule(function()
                    local id_name = query.captures[id]

                    -- If the capture name is "tag" then that means we're dealing with our ranged_tag;
                    if id_name == "tag" then
                        -- Get the range of the code block
                        local range = module.required["core.integrations.treesitter"].get_node_range(node)

                        if module.config.public.dim_code_blocks.conceal then
                            pcall(
                                vim.api.nvim_buf_set_extmark,
                                buf,
                                module.private.code_block_namespace,
                                range.row_start,
                                0,
                                {
                                    end_col = (vim.api.nvim_buf_get_lines(
                                        buf,
                                        range.row_start,
                                        range.row_start + 1,
                                        false
                                    )[1] or ""):len(),
                                    conceal = "",
                                }
                            )
                            pcall(
                                vim.api.nvim_buf_set_extmark,
                                buf,
                                module.private.code_block_namespace,
                                range.row_end,
                                0,
                                {
                                    end_col = (
                                        vim.api.nvim_buf_get_lines(buf, range.row_end, range.row_end + 1, false)[1]
                                        or ""
                                    ):len(),
                                    conceal = "",
                                }
                            )
                        end

                        if module.config.public.dim_code_blocks.adaptive then
                            module.config.public.dim_code_blocks.content_only = has_conceal
                        end

                        if module.config.public.dim_code_blocks.content_only then
                            range.row_start = range.row_start + 1
                            range.row_end = range.row_end - 1
                        end

                        -- Go through every line in the code block and give it a magical highlight
                        for i = range.row_start, range.row_end >= vim.api.nvim_buf_line_count(buf) and 0 or range.row_end, 1 do
                            local line = vim.api.nvim_buf_get_lines(buf, i, i + 1, true)[1]

                            -- If our line is valid and it's not too short then apply the dimmed highlight
                            if line and line:len() >= range.column_start then
                                module.public._set_extmark(
                                    buf,
                                    nil,
                                    "NeorgCodeBlock",
                                    module.private.code_block_namespace,
                                    i,
                                    i + 1,
                                    range.column_start,
                                    nil,
                                    true,
                                    "blend"
                                )
                            else
                                -- There may be scenarios where the line is empty, or the line is shorter than the indentation
                                -- level of the code block, in that case we place the extmark at the very beginning of the line
                                -- and pad it with enough spaces to "emulate" the existence of whitespace
                                module.public._set_extmark(
                                    buf,
                                    { { string.rep(" ", range.column_start) } },
                                    "NeorgCodeBlock",
                                    module.private.code_block_namespace,
                                    i,
                                    i + 1,
                                    0,
                                    nil,
                                    true,
                                    "blend"
                                )
                            end
                        end
                    end
                end)
            end

            schedule(function()
                neorg.lib.map(old_extmarks, function(_, id)
                    vim.api.nvim_buf_del_extmark(buf, module.private.code_block_namespace, id)
                end)
            end)
        end
    end,

    --- Mostly a wrapper around vim.api.nvim_buf_set_extmark in order to make it ¿safer¿
    -- -@param text string|table   # The virtual text to overlay (usually the icon)
    -- -@param highlight string    # The name of a highlight to use for the icon
    -- -@param line_number number  # The line number to apply the extmark in
    -- -@param end_line number     # The last line number to apply the extmark to (useful if you want an extmark to exist for more than one line)
    -- -@param start_column number # The start column of the conceal
    -- -@param end_column number   # The end column of the conceal
    -- -@param whole_line boolean  # If true will highlight the whole line (like in diffs)
    -- -@param mode string         # "replace"/"combine"/"blend" - the highlight mode for the extmark
    -- -@param pos string          # "overlay"/"eol"/"right_align" - the position to place the extmark in (defaults to "overlay")
    -- -@param conceal string      # The char to use for concealing
    _set_extmark = function(
        buf,
        text,
        highlight,
        ns,
        line_number,
        end_line,
        start_column,
        end_column,
        whole_line,
        mode,
        pos,
        conceal
    )
        if not vim.api.nvim_buf_is_loaded(buf) then
            return
        end

        -- If the text type is a string
        -- then convert it into something that Neovim's extmark API can understand
        if type(text) == "string" then
            text = { { text, highlight } }
        end

        -- Attempt to call vim.api.nvim_buf_set_extmark with all the parameters
        pcall(vim.api.nvim_buf_set_extmark ,
              buf                          ,
              ns                           ,
              line_number                  ,
              start_column                 ,
                {
                  end_col      = end_column       ,
                  hl_group      = highlight        ,
                  end_row       = end_line         ,
                  virt_text     = text             ,
                  virt_text_pos = pos or "overlay" ,
                  hl_mode       = mode             ,
                  hl_eol        = whole_line       ,
                  conceal       = conceal          ,
                },
             )
    end,

    --- Gets the already present extmarks in a buffer
        ---@param buf number #The buffer to get the extmarks from
        ---@param namespace number #The namespace to query the extmarks from
        ---@param from? number #The first line to extract the extmarks from
        ---@param to? number #The last line to extract the extmarks from
        ---@return list #A list of extmark IDs
    get_old_extmarks = function(buf, namespace, from, to)
        return neorg.lib.map(
            neorg.lib.inline_pcall(
                vim.api.nvim_buf_get_extmarks ,
                buf                           ,
                namespace                     ,
                from and { from, 0 } or 0     ,
                to and { to, -1 } or -1       ,
                {}
            ) or {},
            function(_, v)
                return v[1]
            end
        )
    end,

    completion_levels = {
        --- Displays the completion level with incremental updates
        ---@param buf number #The number of the buffer to parse
        ---@param line number #The line number the user is at
        trigger_completion_levels_incremental = function(buf, line)
            -- Get the root node of the document (required to iterate over query captures)
            local document_root = module.required["core.integrations.treesitter"].get_document_root(buf)

            if not document_root then
                return
            end

            local current_node = module.required["core.integrations.treesitter"].get_first_node_on_line(buf, line)

            if not current_node or current_node:type() == "document" then
                current_node = module.required["core.integrations.treesitter"].get_ts_utils().get_node_at_cursor()

                if not current_node then
                    return
                end
            end

            local parent = module.required["core.integrations.treesitter"].find_parent(
                current_node,
                vim.tbl_keys(module.config.public.completion_level.queries)
            )

            if not parent then
                return
            end

            local query = module.config.public.completion_level.queries[parent:type()]

            if not query then
                return
            end

            local parent_range = module.required["core.integrations.treesitter"].get_node_range(parent)

            schedule(function()
                module.public.completion_levels.clear_completion_levels(
                    buf,
                    parent_range.row_start,
                    parent_range.row_start + 1
                )

                local todo_item_counts = module.public.completion_levels.get_todo_item_counts(parent)

                if todo_item_counts.total ~= 0 then
                    module.public._set_extmark(
                        buf,
                        module.public.completion_levels.convert_query_syntax_to_extmark_syntax(
                            query.text,
                            todo_item_counts
                        ),
                        query.highlight,
                        module.private.completion_level_namespace,
                        parent_range.row_start,
                        nil,
                        parent_range.column_start,
                        nil,
                        nil,
                        nil,
                        "eol"
                    )
                end
            end)
        end,

        --- Triggers the completion level check for a range of lines
        ---@param buf number #The number of the buffer to trigger completion levels in
        ---@param from? number #The start line
        ---@param to? number #The end line
        trigger_completion_levels = function(buf, from, to)
            module.public.completion_levels.clear_completion_levels(buf, from, to)

            local root = module.required["core.integrations.treesitter"].get_document_root(buf)

            if not root then
                return
            end

            for node_name, data in pairs(module.config.public.completion_level.queries) do
                local ok, query = pcall(
                    vim.treesitter.parse_query,
                    "norg",
                    string.format(
                        [[
                        (%s) @parent
                    ]],
                        node_name
                    )
                )

                if not ok then
                    log.error(
                        "Failed to parse completion level for node type '"
                            .. node_name
                            .. "' - ensure that you're providing a valid node name. Full error: "
                            .. query
                    )
                    return
                end

                for id, node in query:iter_captures(root, buf, from, to) do
                    local capture = query.captures[id]

                    if capture == "parent" then
                        local node_range = module.required["core.integrations.treesitter"].get_node_range(node)

                        schedule(function()
                            module.public.completion_levels.clear_completion_levels(
                                buf,
                                node_range.row_start,
                                node_range.row_start + 1
                            )

                            local todo_item_counts = module.public.completion_levels.get_todo_item_counts(node)

                            if todo_item_counts.total ~= 0 then
                                module.public._set_extmark(
                                    buf,
                                    module.public.completion_levels.convert_query_syntax_to_extmark_syntax(
                                        data.text,
                                        todo_item_counts
                                    ),
                                    data.highlight,
                                    module.private.completion_level_namespace,
                                    node_range.row_start,
                                    nil,
                                    node_range.column_start,
                                    nil,
                                    nil,
                                    nil,
                                    "eol"
                                )
                            end
                        end)
                    end
                end
            end
        end,

        --- Counts the number of todo items under a node
        ---@param start_node userdata #The treesitter node to start at
        ---@return table #A table of data regarding all todo item counts
        get_todo_item_counts = function(start_node)
            local results = { total = 0 }
            count_todo_nodes_under_node(start_node, results)
            return results
        end,

        --- Converts a formatted string to a raw string
        ---@param str string #The formatted string
        ---@param item_counts table #A table of data regarding all todo item counts
        ---@see get_todo_item_counts
        ---@return string #The string with all valid formatting replaced
        substitute_item_counts_in_str = function(str, item_counts)
            local types = {
                "undone",
                "pending",
                "done",
                "on_hold",
                "urgent",
                "cancelled",
                "recurring",
                "uncertain",
            }

            for _, type in ipairs(types) do
                str = str:gsub("<" .. type .. ">", item_counts[type] or 0)
            end

            str = str:gsub("<total>", item_counts.total)
            str = str:gsub("<percentage>", math.floor((item_counts.done or 0) / item_counts.total * 100))

            return str
        end,

        convert_query_syntax_to_extmark_syntax = function(tbl, item_counts)
            local result = vim.deepcopy(tbl)

            for i, item in ipairs(result) do
                if type(item) == "string" then
                    result[i] = { item }
                end

                result[i][1] = module.public.completion_levels.substitute_item_counts_in_str(result[i][1], item_counts)
            end

            return result
        end,

        --- Clears the completion level namespace
        ---@param buf number #The buffer to clear the extmarks in
        ---@param from? number #The start line
        ---@param to? number #The end line
        clear_completion_levels = function(buf, from, to)
            vim.api.nvim_buf_clear_namespace(buf, module.private.completion_level_namespace, from or 0, to or -1)
        end,
    },

    -- VARIABLES
    concealing = {
        ordered = {
            get_index = function(node, level)
                local sibling = node:parent():prev_named_sibling()
                local count = 1

                while sibling and sibling:type() == level do
                    sibling = sibling:prev_named_sibling()
                    count = count + 1
                end

                return count
            end,

            enumerator = {
                numeric = function(count)
                    return tostring(count)
                end,

                latin_lowercase = function(count)
                    return string.char(96 + count)
                end,

                latin_uppercase = function(count)
                    return string.char(64 + count)
                end,

                -- NOTE: only supports number up to 12
                roman_lowercase = function(count)
                    local chars = {
                        [1] = "ⅰ",
                        [2] = "ⅱ",
                        [3] = "ⅲ",
                        [4] = "ⅳ",
                        [5] = "ⅴ",
                        [6] = "ⅵ",
                        [7] = "ⅶ",
                        [8] = "ⅷ",
                        [9] = "ⅸ",
                        [10] = "ⅹ",
                        [11] = "ⅺ",
                        [12] = "ⅻ",
                        [50] = "ⅼ",
                        [100] = "ⅽ",
                        [500] = "ⅾ",
                        [1000] = "ⅿ",
                    }
                    return chars[count]
                end,

                -- NOTE: only supports number up to 12
                roman_uppwercase = function(count)
                    local chars = {
                        [1] = "Ⅰ",
                        [2] = "Ⅱ",
                        [3] = "Ⅲ",
                        [4] = "Ⅳ",
                        [5] = "Ⅴ",
                        [6] = "Ⅵ",
                        [7] = "Ⅶ",
                        [8] = "Ⅷ",
                        [9] = "Ⅸ",
                        [10] = "Ⅹ",
                        [11] = "Ⅺ",
                        [12] = "Ⅻ",
                        [50] = "Ⅼ",
                        [100] = "Ⅽ",
                        [500] = "Ⅾ",
                        [1000] = "Ⅿ",
                    }
                    return chars[count]
                end,
            },

            punctuation = {
                dot = function(renderer)
                    return function(count)
                        return renderer(count) .. "."
                    end
                end,

                parenthesis = function(renderer)
                    return function(count)
                        return renderer(count) .. ")"
                    end
                end,

                double_parenthesis = function(renderer)
                    return function(count)
                        return "(" .. renderer(count) .. ")"
                    end
                end,

                -- NOTE: only supports arabic numbers up to 20
                unicode_dot = function(renderer)
                    return function(count)
                        local chars = {
                            ["1"] = "⒈",
                            ["2"] = "⒉",
                            ["3"] = "⒊",
                            ["4"] = "⒋",
                            ["5"] = "⒌",
                            ["6"] = "⒍",
                            ["7"] = "⒎",
                            ["8"] = "⒏",
                            ["9"] = "⒐",
                            ["10"] = "⒑",
                            ["11"] = "⒒",
                            ["12"] = "⒓",
                            ["13"] = "⒔",
                            ["14"] = "⒕",
                            ["15"] = "⒖",
                            ["16"] = "⒗",
                            ["17"] = "⒘",
                            ["18"] = "⒙",
                            ["19"] = "⒚",
                            ["20"] = "⒛",
                        }
                        return chars[renderer(count)]
                    end
                end,

                -- NOTE: only supports arabic numbers up to 20 or lowercase latin characters
                unicode_double_parenthesis = function(renderer)
                    return function(count)
                        local chars = {
                            ["1"] = "⑴",
                            ["2"] = "⑵",
                            ["3"] = "⑶",
                            ["4"] = "⑷",
                            ["5"] = "⑸",
                            ["6"] = "⑹",
                            ["7"] = "⑺",
                            ["8"] = "⑻",
                            ["9"] = "⑼",
                            ["10"] = "⑽",
                            ["11"] = "⑾",
                            ["12"] = "⑿",
                            ["13"] = "⒀",
                            ["14"] = "⒁",
                            ["15"] = "⒂",
                            ["16"] = "⒃",
                            ["17"] = "⒄",
                            ["18"] = "⒅",
                            ["19"] = "⒆",
                            ["20"] = "⒇",
                            ["a"] = "⒜",
                            ["b"] = "⒝",
                            ["c"] = "⒞",
                            ["d"] = "⒟",
                            ["e"] = "⒠",
                            ["f"] = "⒡",
                            ["g"] = "⒢",
                            ["h"] = "⒣",
                            ["i"] = "⒤",
                            ["j"] = "⒥",
                            ["k"] = "⒦",
                            ["l"] = "⒧",
                            ["m"] = "⒨",
                            ["n"] = "⒩",
                            ["o"] = "⒪",
                            ["p"] = "⒫",
                            ["q"] = "⒬",
                            ["r"] = "⒭",
                            ["s"] = "⒮",
                            ["t"] = "⒯",
                            ["u"] = "⒰",
                            ["v"] = "⒱",
                            ["w"] = "⒲",
                            ["x"] = "⒳",
                            ["y"] = "⒴",
                            ["z"] = "⒵",
                        }
                        return chars[renderer(count)]
                    end
                end,

                -- NOTE: only supports arabic numbers up to 20 or latin characters
                unicode_circle = function(renderer)
                    return function(count)
                        local chars = {
                            ["1"] = "①",
                            ["2"] = "②",
                            ["3"] = "③",
                            ["4"] = "④",
                            ["5"] = "⑤",
                            ["6"] = "⑥",
                            ["7"] = "⑦",
                            ["8"] = "⑧",
                            ["9"] = "⑨",
                            ["10"] = "⑩",
                            ["11"] = "⑪",
                            ["12"] = "⑫",
                            ["13"] = "⑬",
                            ["14"] = "⑭",
                            ["15"] = "⑮",
                            ["16"] = "⑯",
                            ["17"] = "⑰",
                            ["18"] = "⑱",
                            ["19"] = "⑲",
                            ["20"] = "⑳",
                            ["A"] = "Ⓐ",
                            ["B"] = "Ⓑ",
                            ["C"] = "Ⓒ",
                            ["D"] = "Ⓓ",
                            ["E"] = "Ⓔ",
                            ["F"] = "Ⓕ",
                            ["G"] = "Ⓖ",
                            ["H"] = "Ⓗ",
                            ["I"] = "Ⓘ",
                            ["J"] = "Ⓙ",
                            ["K"] = "Ⓚ",
                            ["L"] = "Ⓛ",
                            ["M"] = "Ⓜ",
                            ["N"] = "Ⓝ",
                            ["O"] = "Ⓞ",
                            ["P"] = "Ⓟ",
                            ["Q"] = "Ⓠ",
                            ["R"] = "Ⓡ",
                            ["S"] = "Ⓢ",
                            ["T"] = "Ⓣ",
                            ["U"] = "Ⓤ",
                            ["V"] = "Ⓥ",
                            ["W"] = "Ⓦ",
                            ["X"] = "Ⓧ",
                            ["Y"] = "Ⓨ",
                            ["Z"] = "Ⓩ",
                            ["a"] = "ⓐ",
                            ["b"] = "ⓑ",
                            ["c"] = "ⓒ",
                            ["d"] = "ⓓ",
                            ["e"] = "ⓔ",
                            ["f"] = "ⓕ",
                            ["g"] = "ⓖ",
                            ["h"] = "ⓗ",
                            ["i"] = "ⓘ",
                            ["j"] = "ⓙ",
                            ["k"] = "ⓚ",
                            ["l"] = "ⓛ",
                            ["m"] = "ⓜ",
                            ["n"] = "ⓝ",
                            ["o"] = "ⓞ",
                            ["p"] = "ⓟ",
                            ["q"] = "ⓠ",
                            ["r"] = "ⓡ",
                            ["s"] = "ⓢ",
                            ["t"] = "ⓣ",
                            ["u"] = "ⓤ",
                            ["v"] = "ⓥ",
                            ["w"] = "ⓦ",
                            ["x"] = "ⓧ",
                            ["y"] = "ⓨ",
                            ["z"] = "ⓩ",
                        }
                        return chars[renderer(count)]
                    end
                end,
            },
        },
    },

    --- Custom foldtext to be used with the native folding support
    ---@return string #The foldtext
    foldtext = function()
        local foldstart = vim.v.foldstart
        local line = vim.api.nvim_buf_get_lines(0, foldstart - 1, foldstart, true)[1]

        return neorg.lib.match(line, function(lhs, rhs)
            return vim.startswith(lhs, rhs)
        end)({
            ["@document.meta"] = "Document Metadata",
            _ = function()
                local line_length = vim.api.nvim_strwidth(line)

                local icon_extmarks = vim.api.nvim_buf_get_extmarks(
                    0,
                    module.private.icon_namespace,
                    { foldstart - 1, 0 },
                    { foldstart - 1, line_length },
                    {
                        details = true,
                    }
                )

                for _, extmark in ipairs(icon_extmarks) do
                    local extmark_details = extmark[4]
                    local extmark_column = extmark[3] + (line_length - vim.api.nvim_strwidth(line))

                    for _, virt_text in ipairs(extmark_details.virt_text or {}) do
                        line = line:sub(1, extmark_column)
                            .. virt_text[1]
                            .. line:sub(extmark_column + vim.api.nvim_strwidth(virt_text[1]) + 1)
                        line_length = vim.api.nvim_strwidth(line) - line_length + vim.api.nvim_strwidth(virt_text[1])
                    end
                end

                local completion_extmarks = vim.api.nvim_buf_get_extmarks(
                    0,
                    module.private.completion_level_namespace,
                    { foldstart - 1, 0 },
                    { foldstart - 1, vim.api.nvim_strwidth(line) },
                    {
                        details = true,
                    }
                )

                if not vim.tbl_isempty(completion_extmarks) then
                    line = line .. " "

                    for _, extmark in ipairs(completion_extmarks) do
                        for _, virt_text in ipairs(extmark[4].virt_text or {}) do
                            line = line .. virt_text[1]
                        end
                    end
                end

                return line
            end,
        })
    end,

    toggle_concealer = function()
        module.private.enabled = not module.private.enabled

        if module.private.enabled then
            neorg.events.send_event(
                "core.norg.concealer",
                neorg.events.create(module, "core.autocommands.events.bufenter", {
                    norg = true,
                })
            )
        else
            for _, namespace in ipairs({
                "icon_namespace",
                "code_block_namespace",
                "completion_level_namespace",
            }) do
                vim.api.nvim_buf_clear_namespace(0, module.private[namespace], 0, -1)
            end
        end
    end,
}



