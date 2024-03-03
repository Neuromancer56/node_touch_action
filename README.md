# Node Touch Action
# This mod is heavilly based on the cactus_damage mod by VMan_2002

Pass in a node name and a function, and every time a player touches that node, your custom function executes.

Example:
When adding gameplay, one thing that comes in handy is performing an action when a player touches a node.  For example making a player take hitpoint damage when touching a cactus.
In my Hero Mines game I needed a light to break when a player touched it, and for the player to take damage when touching magma nodes. You can see the magma example below.

Usage:
Add the node_touch_action to the depends statement in your mod.conf file:
depends = default, node_touch_action

After you register your node create a function to be executed when the node is touched:

local function magmaTouchAction(player)
    player:set_hp(player:get_hp() - 1, "magma")
end

Then Register the action to occur when node is touched.  The first parameter is the node name, the second parameter is the funtction that happens when the node is touched.
registerNodeTouchAction("hero_mines:magma", magmaTouchAction)
