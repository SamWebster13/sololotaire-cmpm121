local Game = require("game")

io.stdout:setvbuf("no")

-- Declare a variable to store the background image
local backgroundImage

function love.load()
    love.window.setTitle("Klondike Solitaire")
    love.window.setMode(1024, 768)

    -- Load the background image (make sure the path is correct)
    backgroundImage = love.graphics.newImage("sprites/grass.png")

    -- Initialize the Game module
    Game:load()
end

function love.update(dt)
    Game:update(dt)
end

function love.draw()
    -- Draw the background image first (stretching to fit the screen)
    love.graphics.draw(backgroundImage, 0, 0, 0, love.graphics.getWidth() / backgroundImage:getWidth(), love.graphics.getHeight() / backgroundImage:getHeight())

    -- Now draw the rest of the game (cards, buttons, etc.)
    Game:draw()
end

function love.mousepressed(x, y, button)
    Game:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    Game:mousereleased(x, y, button)
end
