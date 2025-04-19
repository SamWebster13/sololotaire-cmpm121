local Deck = require("deck")
local Tableau = require("tableau")

local Game = {}
Game.__index = Game

function Game:load()
    self.deck = Deck:new()
    self.deck:shuffle()

    self.heldCard = nil
    self.heldCards = {}
    self.dragOffsetX = 0
    self.dragOffsetY = 0
    self.heldFromPile = nil

    self.restartButton = {x = 10, y = 10, w = 100, h = 30}
    self.foundations = {}
    self.piles = {}
    self.stock = {}
    self.waste = {}
    self.cardBack = love.graphics.newImage("sprites/card_back.png")
    
    self.steps = 0
    self.timeElapsed = 0
    self.gameStartTime = love.timer.getTime()

    
    for i = 1, 4 do
        local foundation = Tableau:new(400 + (i - 1) * 100, 50)
        foundation.isFoundation = true
        self.foundations[i] = foundation
    end

    for i = 1, 7 do
        local tableau = Tableau:new(100 + (i - 1) * 100, 150)
        for j = 1, i do
            local card = self.deck:drawTopCard()
            card.faceUp = (j == i)
            tableau:addCard(card)
        end
        self.piles[i] = tableau
    end

    self:updateStockFromDeck()
end

function Game:updateStockFromDeck()
    for i = #self.deck.cards, 1, -1 do
        self.stock[#self.stock + 1] = self.deck:drawTopCard()
    end
end

function Game:update(dt)
    self.timeElapsed = love.timer.getTime() - self.gameStartTime
    if self.heldCard then
        local mx, my = love.mouse.getPosition()
        for i, card in ipairs(self.heldCards) do
            card.x = mx - self.dragOffsetX
            card.y = my - self.dragOffsetY + (i - 1) * 20
            
        end
    end
end

function Game:draw()
    -- Draw foundations and suit symbols
    local suits = {"H", "D", "S", "C"}  -- Hearts, Diamonds, Spades, Clubs
    for i, foundation in ipairs(self.foundations) do
        foundation:draw()

        -- Draw the suit symbol in the top-left corner of the foundation
        love.graphics.setFont(love.graphics.newFont(20))  -- You can adjust the font size
        love.graphics.setColor(0, 0, 0)  -- Set color to white for contrast
        love.graphics.print(suits[i], foundation.x + 28, foundation.y + 38)  -- Adjust position
    end

    -- Draw the restart button
    love.graphics.setColor(0.8, 0.1, 0.1)
    love.graphics.rectangle("fill", self.restartButton.x, self.restartButton.y, self.restartButton.w, self.restartButton.h)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Restart", self.restartButton.x + 10, self.restartButton.y + 8)
    
    -- Draw steps and time elapsed
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(string.format("Steps: %d", self.steps), 125, 18)

    local minutes = math.floor(self.timeElapsed / 60)
    local seconds = math.floor(self.timeElapsed % 60)
    love.graphics.print(string.format("Time: %02d:%02d", minutes, seconds), 240, 18)

    -- Draw tableau piles
    for _, tableau in ipairs(self.piles) do
        tableau:draw()
    end

    -- Draw stock
    if #self.stock > 0 then
      local scale = 0.4 
    love.graphics.draw(self.cardBack, 100, 50, 0, scale, scale)  -- Apply scaling here
    end

    -- Draw waste cards
    for i = 1, math.min(3, #self.waste) do
        local card = self.waste[#self.waste - 3 + i]
        if card then
            card.x = 200 + (i - 1) * 20
            card.y = 50
            card:draw()
        end
    end

    -- Draw held cards
    if self.heldCard then
        for _, card in ipairs(self.heldCards) do
            card:draw()
        end
    end

    -- Draw foundation borders and cards
    for _, foundation in ipairs(self.foundations) do
        love.graphics.setColor(0, 0, 0)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", foundation.x, foundation.y, 71, 96)  -- Border for foundation
        love.graphics.setColor(1, 1, 1)

        local top = foundation.cards[#foundation.cards]
        if top then
            top.x = foundation.x
            top.y = foundation.y
            top:draw()
        end
    end
end


function Game:mousepressed(x, y, button)
    if button ~= 1 then return end

    if x >= self.restartButton.x and x <= self.restartButton.x + self.restartButton.w and
       y >= self.restartButton.y and y <= self.restartButton.y + self.restartButton.h then
        self:load()
        return
    end

    if x >= 100 and x <= 171 and y >= 50 and y <= 146 then
        if #self.stock > 0 then
          self.steps = self.steps + 1
            for _ = 1, 3 do
                local card = table.remove(self.stock)
                if not card then break end
                card.faceUp = true
                self.waste[#self.waste + 1] = card
            end
        elseif #self.waste > 0 then
            for i = #self.waste, 1, -1 do
                local card = table.remove(self.waste, i)
                card.faceUp = false
                self.stock[#self.stock + 1] = card
            end
        end
        return
    end

    local topWaste = self.waste[#self.waste]
    if topWaste and topWaste:contains(x, y) then
        self.heldCard = topWaste
        self.heldCards = {topWaste}
        self.dragOffsetX = x - topWaste.x
        self.dragOffsetY = y - topWaste.y
        self.heldFromPile = "waste"
        table.remove(self.waste)
        return
    end

    for _, tableau in ipairs(self.piles) do
        local cards = tableau:getFaceUpCardsAt(x, y)
        if #cards > 0 then
            self.heldCard = cards[1]
            self.heldCards = cards
            self.dragOffsetX = x - self.heldCard.x
            self.dragOffsetY = y - self.heldCard.y
            tableau:removeCards(cards)
            self.heldFromPile = tableau
            return
        end
    end
end

function Game:mousereleased(x, y, button)
    if button ~= 1 or not self.heldCard then return end

    local placed = false

    for _, tableau in ipairs(self.piles) do
        if tableau:isPointInside(x, y) and tableau:canAcceptCard(self.heldCard) then
            for _, card in ipairs(self.heldCards) do
                tableau:addCard(card)
            end
            placed = true
            self.steps = self.steps + 1

            break
        end
    end

    if not placed then
        for _, foundation in ipairs(self.foundations) do
            if foundation:isPointInside(x, y) and foundation:canAcceptToFoundation(self.heldCard) then
                for _, card in ipairs(self.heldCards) do
                    foundation.cards[#foundation.cards + 1] = card
                end
                placed = true
                self.steps = self.steps + 1

                break
            end
        end
    end

    if not placed then
        local target = self.heldFromPile
        if target == "waste" then
            for _, card in ipairs(self.heldCards) do
                self.waste[#self.waste + 1] = card
            end
        elseif target then
            for _, card in ipairs(self.heldCards) do
                target:addCard(card)
            end
        end
    end

    if self.heldFromPile and type(self.heldFromPile) ~= "string" then
        local top = self.heldFromPile.cards[#self.heldFromPile.cards]
        if top and not top.faceUp then
            top.faceUp = true
        end
    end

    self.heldCard = nil
    self.heldCards = {}
    self.heldFromPile = nil

    -- (debugging print can be removed)
    for i, foundation in ipairs(self.foundations) do
        print("Foundation " .. i .. " type:", tostring(getmetatable(foundation)))
    end
end

return Game
