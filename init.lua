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

--get the x & z position offsets of the touched node relative to the player position.
function get_direction_offsets(player)
    local yaw = player:get_look_horizontal()
    local yaw_degrees = (yaw + 2 * math.pi) % (2 * math.pi) * 180 / math.pi

    local x_offset = 0
    local z_offset = 0

    if yaw_degrees >= 225 and yaw_degrees < 315 then
        x_offset = 1
    elseif yaw_degrees >= 45 and yaw_degrees < 135 then
        x_offset = -1
    end

    if yaw_degrees >= 315 or yaw_degrees < 45 then
        z_offset = 1
    elseif yaw_degrees >= 135 and yaw_degrees < 225 then
        z_offset = -1
    end

    return x_offset, z_offset
end

-- Example usage:
-- Define your action function
--[[
local function cactusTouchAction(player)
    player:set_hp(player:get_hp() - 1, "cactus")
	
	--optional:
	local pos = player:get_pos()
	local x_offset, z_offset= get_direction_offsets(player)
	local touched_pos = {x = pos.x + x_offset, y = pos.y, z = pos.z + z_offset}  --note you may need to adjust the y position depending on your situation
	
end

-- Register global touch action for cactus nodes
registerNodeTouchAction("default:cactus", cactusTouchAction)
]]