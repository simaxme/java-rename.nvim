local symbol_usage = {}

local buffer = require("simaxme-java.rename.buffer")
local file_refactor = require("simaxme-java.rename.file-refactor")

-- will generate a regex for looking for symbol usages inside the current buffer
-- @param class_name the class_name or symbol to look for
function symbol_usage.generate_regex(class_name)
    return string.format(
        "[%%s,;%%(}<]%s[%%s,;%%(}%%.>]",
        class_name
    )
end

-- will replace all symbol usages in the current buffer file
-- @param old_class_name the old class name
-- @param new_class_name the new class name
function symbol_usage.replace_symbol_usage(file_path, old_class_name, new_class_name)
    local regex = symbol_usage.generate_regex(old_class_name)

    -- local lines = buffer.read_buffer_lines()
    local lines = file_refactor.get_file_content(file_path)

    local index = 0

    while index ~= nil do
        local index_start, index_end = string.find(lines, regex, index)

        if index_start == nil or index_end == nil then
            break
        end

        lines = lines:sub(0, index_start) ..
            new_class_name ..
            lines:sub(index_end, #lines)

        index = index_end
    end

    file_refactor.add_rewrite_request(file_path, lines)
    -- buffer.write_buffer_lines(lines)
end

return symbol_usage
