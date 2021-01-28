-- Functions for text manipulation

local expect = (require "cc.expect").expect

-- Clips the text if it is longer than the given width
-- Replaces the last available characters by the cutoff string
local function clipText(text, width, cutoff)
    expect(1, text, "string")
    expect(2, width, "number")
    expect(3, cutoff, "string", "nil")

    if (cutoff == nil) then cutoff = "..." end

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

    local spaces = (width - #text) / 2
    return string.rep(" ", math.floor(spaces)) .. text .. string.rep(" ", math.ceil(spaces))
end

function formatNumber(number)
    if (number > 1000000000) then
        return math.floor((number/1000000) + 0.5) / 1000 .. " B"
    elseif (number > 1000000) then
        return math.floor((number/1000) + 0.5) / 1000 .. " M"
    elseif (number > 1000) then
        return math.floor(number + 0.5) / 1000 .. " K"
    else
        return math.floor(number + 0.5) .. " "
    end
end

local function writeCenteredText(text, x, y, width, cutoff)
    expect(1, text, "string")
    expect(2, width, "number")
    expect(3, x, "number")
    expect(4, y, "number")
    expect(5, cutoff, "string", "nil")

    term.setCursorPos(x, y)
    term.write(centeredText(text, width, cutoff))
end

return {
    clipText = clipText,
    centeredText = centeredText,
    formatNumber = formatNumber,
    writeCenteredText = writeCenteredText
}
