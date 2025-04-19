local Card = {}
Card.__index = Card

function Card:new(suit, rank, faceUp)
    local imgPath = "sprites/" .. suit .. rank .. ".png"
    local self = setmetatable({
        suit = suit,
        rank = rank,
        faceUp = faceUp or false,
        
        -- Load the front and back card images
        image = love.graphics.newImage(imgPath),
        back = love.graphics.newImage("sprites/card_back.png"),
        
        -- Set consistent dimensions for both the front and back images
        width = 71,
        height = 96
    }, Card)
    
    -- You could adjust here if your images need to be pre-scaled
    return self
end

function Card:draw(scale)
    -- Default scale to 0.4 if not provided
    scale = scale or 0.4
    
    -- Choose the appropriate image (face-up or back)
    local img = self.faceUp and self.image or self.back
    
    -- Get the original width and height of the image
    local imgWidth, imgHeight = img:getDimensions()
    
    -- Draw the image with scaling
    love.graphics.draw(img, self.x, self.y, 0, scale, scale)
end

function Card:contains(x, y)
    return x >= self.x and x <= self.x + self.width and
           y >= self.y and y <= self.y + self.height
end

function Card:getColor()
    if self.suit == "cardHearts" or self.suit == "cardDiamonds" then
        return "red"
    else
        return "black"
    end
end

function Card:getValue()
    local values = {
        A = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4,
        ["5"] = 5, ["6"] = 6, ["7"] = 7, ["8"] = 8,
        ["9"] = 9, ["10"] = 10, J = 11, Q = 12, K = 13
    }
    return values[self.rank]
end

return Card
