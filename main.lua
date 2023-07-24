local error = nil

local function clear_package_cache()
    for pkg in pairs(package.loaded) do
        package.loaded[pkg] = nil
    end
end

local function run_handling_errors(func, ...)
    local success, ret = xpcall(func, function(err)
        print("Error: " .. err)
        error = err
    end, ...)

    if success then
        error = nil
        return ret
    end

    return nil
end

local game = run_handling_errors(require, "game")

local function hot_reload()
    clear_package_cache()
    local new_game = run_handling_errors(require, "game")

    if game then
        -- Don't preserve the old game's functions, but do preserve its state.
        for name, value in pairs(game) do
            if type(value) ~= "function" then
                new_game[name] = game[name]
            end
        end
    end

    game = new_game
end

if game then
    run_handling_errors(game.init)
end

function love.keypressed(key, scancode, isrepeat)
    if key == "f5" then
        print("Hot Reloading...")
        hot_reload()
    end
end

function love.update(dt)
    if error then
        return
    end

    if game then
        run_handling_errors(game.update, dt)
    end
end

function love.draw()
    if error then
        love.graphics.clear()
        love.graphics.print(error, 0, 0)
        return
    end

    if game then
        run_handling_errors(game.draw)
    end
end
