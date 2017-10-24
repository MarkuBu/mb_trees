
--
-- Bamboo
--

-- Thanks to VanessaE, Tenplus1, paramat and all others who
-- contribute to this mod

bamboo = {}


-- bamboo stalk with leaves

local ai = {name = "air", param1 = 000}
local bt = {name = "bamboo:trunk", param1 = 255}
local bf = {name = "bamboo:trunk", param1 = 255, force_place = true}
local fd = {name = "default:dirt", param1 = 255, force_place = true}
local lp = {name = "bamboo:leaves", param1 = 255}
local lr = {name = "bamboo:leaves", param1 = 100}

bamboo.bambootree = {

	size = {x = 3, y = 18, z = 3},

	data = {

		ai, ai, ai,
		ai, ai, ai,
		ai, ai, ai,
		ai, ai, ai,
		ai, ai, ai,
		ai, ai, ai,
		ai, ai, ai,
		ai, ai, ai,
		ai, ai, ai,
		ai, ai, ai,
		ai, ai, ai,
		ai, ai, ai,
		ai, ai, ai,
		ai, ai, ai,
		lr, lr, lr,
		lr, lp, lr,
		ai, lp, ai,
		ai, ai, ai,

		ai, fd, ai,
		ai, bf, ai,
		ai, bt, ai,
		ai, bt, ai,
		ai, bt, ai,
		ai, bt, ai,
		ai, bt, ai,
		ai, bt, ai,
		ai, bt, ai,
		ai, bt, ai,
		ai, bt, ai,
		ai, bt, ai,
		ai, bt, ai,
		ai, bt, ai,
		lr, bt, lr,
		lr, lp, lr,
		ai, lp, ai,
		ai, lr, ai,

		ai, ai, ai,
		ai, ai, ai,
		ai, ai, ai,
		ai, ai, ai,
		ai, ai, ai,
		ai, ai, ai,
		ai, ai, ai,
		ai, ai, ai,
		ai, ai, ai,
		ai, ai, ai,
		ai, ai, ai,
		ai, ai, ai,
		ai, ai, ai,
		ai, ai, ai,
		lr, lr, lr,
		lr, lp, lr,
		ai, lp, ai,
		ai, ai, ai,

	},

	yslice_prob = {
		{ypos = 3, prob = 127},
		{ypos = 4, prob = 127},
		{ypos = 5, prob = 127},
		{ypos = 6, prob = 127},
		{ypos = 7, prob = 127},
		{ypos = 8, prob = 127},
		{ypos = 9, prob = 127},
		{ypos = 10, prob = 127},
		{ypos = 11, prob = 127},
		{ypos = 12, prob = 127},
	},
}


local function grow_new_bamboo(pos)
	if not default.can_grow(pos) then
		-- try a bit later again
		minetest.get_node_timer(pos):start(math.random(240, 600))
		return
	end

	minetest.place_schematic({x = pos.x - 1, y = pos.y - 1, z = pos.z - 1},
		bamboo.bambootree, "0", nil, false)
end

--
-- Decoration
--


minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"default:dirt_with_grass"},
	sidelen = 16,
	noise_params = {
		offset = 0.05,
		scale = 0.001,
		spread = {x = 250, y = 250, z = 250},
		seed = 2776,
		octaves = 3,
		persist = 0.66
	},
	biomes = {"grassland"},
	y_min = 2,
	y_max = 20,
	schematic = bamboo.bambootree,
	flags = "place_center_x, place_center_z",
})

--
-- Nodes
--

-- Bamboo (thanks to Nelo-slay on DeviantArt for the free Bamboo base image)
minetest.register_node("bamboo:trunk", {
	description = "Bamboo",
	drawtype = "plantlike",
	tiles = {"bamboo.png"},
	inventory_image = "bamboo.png",
	wield_image = "bamboo.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = true,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3}
	},
	groups = {choppy = 3, oddly_breakable_by_hand = 1, flammable = 2, tree = 1},
	sounds = default.node_sound_leaves_defaults(),
	after_dig_node = function(pos, node, metadata, digger)
		default.dig_up(pos, node, digger)
	end,

})

-- bamboo stalk leaves
minetest.register_node("bamboo:leaves", {
	description = "Bamboo Leaves",
	drawtype = "allfaces_optional",
	visual_scale = 1.2,
	tiles = {"bamboo_leaves.png"},
	inventory_image = "bamboo_leaves.png",
	wield_image = "bamboo_leaves.png",
	paramtype = "light",
	walkable = true,
	waving = 1,
	groups = {snappy = 3, leafdecay = 3, leaves = 1, flammable = 2},
	drop = {
		max_items = 1,
		items = {
			{items = {"bamboo:sprout"}, rarity = 10},
			{items = {"bamboo:leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
})


-- Bamboo Sprout
minetest.register_node("bamboo:sprout", {
	description = "Bamboo Sprout",
	drawtype = "plantlike",
	tiles = {"bamboo_sprout.png"},
	inventory_image = "bamboo_sprout.png",
	wield_image = "bamboo_sprout.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {
		snappy = 3, attached_node = 1, flammable = 2,
		dig_immediate = 3, ethereal_sapling = 1
	},
	sounds = default.node_sound_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 0, 4 / 16}
	},
	on_use = minetest.item_eat(2),
	grown_height = 11,
})


default.register_leafdecay({
	trunks = {"bamboo:trunk"},
	leaves = {"bamboo:leaves"},
	radius = 3,
})
