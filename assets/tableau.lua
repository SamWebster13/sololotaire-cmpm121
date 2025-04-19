local Tableau = {}
Tableau.__index = Tableau

function Tableau:new(x, y)
    return setmetatable({
        x = x,
        y = y,
        cards = {}
    }, Tableau)
end

function Tableau:addCard(card)
    card.x = self.x
    card.y = self.y + (#self.cards * 20)
    table.insert(self.cards, card)
end

function Tableau:draw()
    if #self.cards == 0 then
        love.graphics.setColor(0.2, 0.6, 0.2)
        love.graphics.rectangle("line", self.x, self.y, 71, 96)
        love.graphics.setColor(1, 1, 1)
    end

    local offset = self.isFoundation and 0 or 20
    for i, card in ipairs(self.cards) do
        card.x = self.x
        card.y = self.y + (i - 1) * offset
        card:draw()
    end
end

function Tableau:isPointInside(x, y)
    local height = (#self.cards - 1) * 20 + 96
    return x >= self.x and x <= self.x + 71 and y >= self.y and y <= self.y + height
end

function Tableau:isFoundationPointInside(x, y)
    return x >= self.x and x <= self.x + 71 and y >= self.y and y <= self.y + 96
end

function Tableau:getFaceUpCardsAt(x, y)
    for i = #self.cards, 1, -1 do
        local card = self.cards[i]
        if card.faceUp and card:contains(x, y) then
            local selected = {}
            for j = i, #self.cards do
                table.insert(selected, self.cards[j])
            end
            return selected
        end
    end
    return {}
end

function Tableau:removeCards(cards)
    for _ = 1, #cards do
        table.remove(self.cards)
    end
end

function Tableau:canAcceptCard(card)
    local top = self.cards[#self.cards]
    if not top then return card.rank == "K" end

    local color1, color2 = top:getColor(), card:getColor()
    if color1 == color2 then return false end

    local rankOrder = {
        A = 1, ["02"] = 2, ["03"] = 3, ["04"] = 4, ["05"] = 5, ["06"] = 6,
        ["07"] = 7, ["08"] = 8, ["09"] = 9, ["10"] = 10, J = 11, Q = 12, K = 13
    }

    return rankOrder[card.rank] == rankOrder[top.rank] - 1
end

function Tableau:canAcceptToFoundation(card)
    if not self.isFoundation then return false end

    local top = self.cards[#self.cards]
    if not top then
        return card.rank == "A"  -- Ace check, assuming rank is a string "A", "2", etc.
    end

    local rankOrder = {
        A = 1, ["02"] = 2, ["03"] = 3, ["04"] = 4, ["05"] = 5, ["06"] = 6,
        ["07"] = 7, ["08"] = 8, ["09"] = 9, ["10"] = 10, J = 11, Q = 12, K = 13
    }

    return card.suit == top.suit and rankOrder[card.rank] == rankOrder[top.rank] + 1
end

return Tableau
