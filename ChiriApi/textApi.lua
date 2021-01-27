-- Functions for text manipulation

-- Clips the text if it is longer than the given width
-- Replaces the last available characters by the cutoff string
local function clipText(text, width, cutoff)
    if (text == nil) then return nil end

    cutoff = cutoff or "..."
    if (width <= #cutoff) then
        error("Max width must be higher than the cutoff string length")
        return nil
    end

    if (#text <= width) then
        return text
    else
        return string.sub(text, 1, width - #cutoff) .. cutoff
    end
end

local function centeredText(text, width, cutoff)
    text = clipText(text, width)

    if (text == nil) then return nil end

    local spaces = (Width - #text) / 2
    return string.rep(" ", math.floor(spaces)) .. text .. string.rep(" ", math.ceil(spaces))
end

return {
    clipText = clipText,
    centeredText = centeredText
}
