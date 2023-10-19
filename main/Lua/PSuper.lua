-- Poly/Seth's (easy) 2.2 port
-- I didn't make this one either.
-- I don't know who did, but whoever did, they did.
addHook("ThinkFrame", do
	for player in players.iterate
		if true
			if not (player.charflags & SF_SUPER)
				player.charflags = $1 + SF_SUPER
			end
		end
	end
end)

-- Small edit by Seth/Poly, original not by me!
-- Made to work in 2.2.0

-- Smaller edit by Gemini0!
-- Made to make the transformation message less confusing-- and by that, I mean outright removing it. Also, yeah... I hate Match emeralds. No, wait, sorry, I mean "Power Stones"--
local coopEmeralds = {}
coopEmeralds[1] = MT_EMERALD1
coopEmeralds[2] = MT_EMERALD2
coopEmeralds[3] = MT_EMERALD3
coopEmeralds[4] = MT_EMERALD4
coopEmeralds[5] = MT_EMERALD5
coopEmeralds[6] = MT_EMERALD6
coopEmeralds[7] = MT_EMERALD7

local function Turnsuper(player)
	if true -- this block is just a placeholder thing
		if not player.mo return end 
		if not player.mo.health return end 
		if player.powers[pw_super] return end
		P_DoSuperTransformation(player, true) 
		P_GivePlayerRings(player, 9999)
	end
end

local function Turnbacknormal(player)
	if not player.mo return end 
	if not player.mo.health return end  
	if player.powers[pw_super]
        P_GivePlayerRings(player, -9999)
end end

COM_AddCommand("superon", function(player)
	Turnsuper(player)
end)

COM_AddCommand("givemepowerstones", function(player)
	if not player.mo return end
	if not player.mo.health return end
	if player.powers[pw_super] return end
	player.powers[pw_emeralds] = 127
end)

COM_AddCommand("coopemeralds", function(player)
	if not player.mo return end
	if not player.mo.health return end
	if player.powers[pw_super] return end
	if G_RingSlingerGametype() return end
	if coopEmeralds == 127 return end
	for i,mt in ipairs(coopEmeralds)
		P_SpawnMobj(player.mo.x,player.mo.y,player.mo.z,mt)
	end
end, 1)


COM_AddCommand("superoff", function(player)
	Turnbacknormal(player)
end)

-- Poly: There's no way to give Coop/SP coopEmeralds? ;w;
-- Gem: bro you just did