function registerNodeTouchAction(node_name, action_function)
    local get_connected_players = minetest.get_connected_players
    local wait_table = {}

    local function blockWithinRange(xs, ys, zs, xe, ye, ze, name)
        for x = math.floor(xs), math.floor(xe) do
            for y = math.floor(ys), math.floor(ye) do
                for z = math.floor(zs), math.floor(ze) do
                    if minetest.get_node({x=x, y=y, z=z}).name == name then
                        return true
                    end
                end
            end
        end
        return false
    end

    local function blockTouching(player, name)
        local pos = player:get_pos()
        local spd = player:get_velocity()
        local spdy = math.min(player:get_velocity().y / 10, -0.8)
        --return blockWithinRange(pos.x + 0.15, pos.y - 0.08 + spdy, pos.z + 0.15, pos.x + 0.85, pos.y + 2 + spdy, pos.z + 0.85, name)  --original
		--return blockWithinRange(pos.x + 0.15, pos.y - 0.58 + spdy, pos.z + 0.15, pos.x + 0.85, pos.y + 2.5 + spdy, pos.z + 0.85, name)  --too high above still causing action 
        --return blockWithinRange(pos.x + 0.15, pos.y  + 0.15, pos.z + 0.15, pos.x + 0.85, pos.y + 0.15 , pos.z + 0.85, name) 
        return blockWithinRange(pos.x + 0.15, pos.y + 0.5 , pos.z + 0.15, pos.x + 0.85, pos.y + 2.25 , pos.z + 0.85, name)
        --first y is above.  1 to 0   +1 seems to be I have to go too far down.  +0 is not far down enough  +.5 seems just right.
        --second y is from below +2.5 is I don't have to go quite high enough, +2 is just about right maybe have to goa touch too high  +1 is have to go way too high +2.25 seems just right
    end

    minetest.register_globalstep(function(dtime)
        for _, player in pairs(get_connected_players()) do
            local pname = player:get_player_name()
            if not wait_table[pname] then
                if blockTouching(player, node_name) then
                    action_function(player)
                    wait_table[pname] = true
                    minetest.after(0.5, function() wait_table[pname] = nil end)
                end
            end
        end
    end)
end

-- Example usage:
-- Define your action function
--[[
local function cactusAction(player)
    player:set_hp(player:get_hp() - 1, "cactus")
end

-- Register global step action for cactus nodes
registerNodeTouchAction("default:cactus", cactusAction)
]]