/*
	WINGS OBJECT
*/
freeslot(
"SPR_MWNG",
"SPR_SWNG",
"SPR_GWNG",
"SPR_FWNG",
"SPR_CWNG",
"SPR_AWNG",
"SPR_MOWG",
"MT_WINGS",
"S_WING"
)

local wingspritenames = 
{
["METAKNIGHT"]={sprite=SPR_MWNG},
["SCRIBBLE"]={sprite=SPR_SWNG},
["GALACTA"]={sprite=SPR_GWNG},
["FLANDRE"]={sprite=SPR_FWNG},
["CIRNO"]={sprite=SPR_CWNG},
["ANGEL"]={sprite=SPR_AWNG},
["MOKOU"]={sprite=SPR_MOWG}
}

mobjinfo[MT_WINGS] = {

	doomednum = -1,
	spawnstate = S_WING,
	spawnhealth = 1000,
	radius = 48<<FRACBITS,
	height = 48<<FRACBITS,
	flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY
}
states[S_WING] = {SPR_NULL, FF_PAPERSPRITE, -1, nil, 0, 0, S_WING}

-- have the wings follow us
local function WI_updateWings(p, g)
	local mo = p.mo
	if not mo.wi_wings or not #mo.wi_wings return end	-- no wings to update, we're good to go

	local ang = p.drawangle + mo.wi_wingangle	-- arbitrary angle
	local dist = 10

	local wingremoval

	for i = 1, 2 do
		local w = mo.wi_wings[i]
		if not w or not w.valid continue end

		w.sprite = wingspritenames[p.wingtype]["sprite"]	-- update sprite

		-- get correct xy position:
		local x = mo.x + FixedMul(mo.scale, dist*cos(ang))
		local y = mo.y + FixedMul(mo.scale, dist*sin(ang))

		-- get correct z position: use P_SpawnMobjFromMobj for a hack:
		local dum = P_SpawnMobjFromMobj(mo, 0, 0, mo.scale*mo.wi_wingz, MT_WINGS)
		local z = dum.z
		if dum and dum.valid
			P_RemoveMobj(dum)	-- bye
		end

		P_TeleportMove(w, x, y, z)
		w.angle = ang
		w.scale = mo.scale

		if mo.flags2 & MF2_DONTDRAW
			w.flags2 = $|MF2_DONTDRAW
		else
			w.flags2 = $ & ~MF2_DONTDRAW
		end	-- match flashtics

		if mo.eflags & MFE_VERTICALFLIP
			w.eflags = $|MFE_VERTICALFLIP
		else
			w.flags = $ & ~MFE_VERTICALFLIP
		end	-- match mobjflip

		if w.fuse
			local translevel = 10 - w.fuse
			w.frame = ($ & ~FF_TRANSMASK) | (translevel << FF_TRANSSHIFT)

			if w.fuse == 1
				wingremoval = true
			end
		end

		ang = p.drawangle - mo.wi_wingangle	-- ready angle for 2nd wing
	end

	if wingremoval	-- fuse has expired
		for i = 1, 2
			P_RemoveMobj(mo.wi_wings[i])
		end
		mo.wi_wings = nil	-- remove wings & kill the table
	end
end

rawset(_G, "WI_spawnWings", function(p, ang, z)
	local mo = p.mo
	if mo.wi_wings and #mo.wi_wings
		mo.wi_wingangle = ang or ANG1*100
		mo.wi_wingz = z or 60	-- update this nevertheless
		return
	end	-- wings already spawned, do set the angle however

	mo.wi_wings = {}
	for i = 1, 2

		local w = P_SpawnMobj(0,0,0, MT_WINGS)
		w.target = mo
		mo.wi_wings[i] = w
	w.fuse = 0
	end
	mo.wi_wingangle = ang or ANG1*100	-- allow setting custom angle.
	mo.wi_wingz = z or 60

	WI_updateWings(p, true)	-- directly teleport the wings to their correct position!
end)

-- prepare wing despawning
rawset(_G, "WI_despawnWings", function(p, force)
	local mo = p.mo
	if not mo.wi_wings or not #mo.wi_wings return end	-- no wings to update, we're good to go

	for i = 1, 2 do
		if not mo.wi_wings[i] or not mo.wi_wings[i].valid
			continue
		end
		if mo.wi_wings[i].fuse continue end	-- already applied.
		mo.wi_wings[i].fuse = force or 10
	end
end)

COM_AddCommand("wings", function(p, firstwingstate, unused)
  local wingtype
  if not p or not p.mo or not p.mo.valid
    CONS_Printf(p, "You can't use this command right now!")
  else
    if unused
      CONS_Printf(p, "Ignoring anything after the first parameter...")      
    end
    if not firstwingstate or string.lower(firstwingstate) == "help" or firstwingstate == "/?"
      CONS_Printf(p, "wings <type> to remove your current wings. Valid wing types are:")
	  CONS_Printf(p, "angel / kanade")
	  CONS_Printf(p, "cirno / baka / idiot / 9")
	  CONS_Printf(p, "flandre / scarletsister")
	  CONS_Printf(p, "galactaknight / galacta")
	  CONS_Printf(p, "metaknight / meta")
	  CONS_Printf(p, "scribblenauts / scribble")
	  CONS_Printf(p, "mokou / fujiwara / flame / fire / phoenix")
	  CONS_Printf(p, "no / off / none / false / 0")
      return
	elseif string.lower(firstwingstate) == "angel" or string.lower(firstwingstate) == "kanade"
	  p.wingtype = "ANGEL"
	elseif string.lower(firstwingstate) == "cirno" or string.lower(firstwingstate) == "baka" or string.lower(firstwingstate) == "idiot" or string.lower(firstwingstate) == "9"
	  p.wingtype = "CIRNO"
	elseif string.lower(firstwingstate) == "flandre" or string.lower(firstwingstate) == "scarletsister"
	  p.wingtype = "FLANDRE"
	elseif string.lower(firstwingstate) == "galactaknight" or string.lower(firstwingstate) == "galacta"
	  p.wingtype = "GALACTA"
	elseif string.lower(firstwingstate) == "metaknight" or string.lower(firstwingstate) == "meta"
	  p.wingtype = "METAKNIGHT"
	elseif string.lower(firstwingstate) == "scribblenauts" or string.lower(firstwingstate) == "scribble"
	  p.wingtype = "SCRIBBLE"
	elseif string.lower(firstwingstate) == "mokou" or string.lower(firstwingstate) == "fujiwara" or string.lower(firstwingstate) == "flame" or string.lower(firstwingstate) == "fire" or string.lower(firstwingstate) == "phoenix"
	  p.wingtype = "MOKOU"
    elseif string.lower(firstwingstate) == "no" or string.lower(firstwingstate) == "off" or string.lower(firstwingstate) == "none" or string.lower(firstwingstate) == "false" or firstwingstate == "0"
	  firstwingstate = "0"
	  p.wingtype = nil
	else
	  CONS_Printf(p, "You have entered an incorrect wing type.")
      return
    end
	if p and p.mo and p.mo.valid and p.mo.wi_wings 
	  for i = 1, 2
		P_RemoveMobj(p.mo.wi_wings[i])
	  end
	  p.mo.wi_wings = nil
    end
    if p.wingtype == nil
	  return
    else
		WI_spawnWings(p)
 //     p.hat = 1
    end
  end  
end)

addHook("PlayerSpawn", function(player)
	if (player.wingtype)
	 WI_spawnWings(player)
	else
  end
end)

addHook("ThinkFrame", function(player)
  for player in players.iterate do
    if player and player.mo and player.mo.valid and player.wingtype and player.playerstate == PST_LIVE then
      WI_updateWings(player)
    else
	  WI_despawnWings(player)
	end
  end
end)