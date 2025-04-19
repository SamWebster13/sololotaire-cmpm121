-- Require the Card module so we can use Card objects
local Card = require("card")

-- Create a new table for the Deck class and set its metatable
local Deck = {}
Deck.__index = Deck

-- Enables object-oriented behavior
setmetatable(Deck, {
    __call = function(cls, ...)
        return cls.new(...)
    end
})

-- Define the four suits with prefixes matching the card image filenames
local suits = {"cardHearts", "cardDiamonds", "cardClubs", "cardSpades"}

-- Define the 13 card ranks from Ace to King
local ranks = { "A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K" }

-- Constructor function to create a new Deck object
function Deck.new()
    local self = setmetatable({cards = {}}, Deck)
    for _, suit in ipairs(suits) do
        for _, rank in ipairs(ranks) do
            table.insert(self.cards, Card:new(suit, rank))
        end
    end
    return self
end

-- Shuffle method using the Fisher-Yates shuffle algorithm
function Deck:shuffle()
    -- Start from the last card and go backwards
    for i = #self.cards, 2, -1 do
        -- Pick a random index from 1 to i
        local j = math.random(1, i)

        -- Swap the cards at index i and j
        self.cards[i], self.cards[j] = self.cards[j], self.cards[i]
    end
end

-- Draw all cards in the deck (e.g., for visualizing or debugging)
function Deck:drawAll()
    -- Loop through each card and call its draw method
    for _, card in ipairs(self.cards) do
        card:draw()
    end
end

-- Draw a single card from the top of the deck
function Deck:drawTopCard()
    -- Remove and return the last card in the list (top of deck)
    return table.remove(self.cards)
end

-- Return the Deck module so it can be required by other files
return Deck
