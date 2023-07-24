local game = {}

function game.init()
    game.a = 5
end

function game.update(dt)
    game.a = game.a + 1
end

function game.draw()
    love.graphics.clear(0.0, 0.2, 0.6)
    love.graphics.print(tostring(game.a), 0, 0)
end

return game