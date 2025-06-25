local function go_time(plmo,mo)
	S_StartSound(plmo, sfx_pop)
	local icon = P_SpawnMobjFromMobj(plmo,0,0,plmo.height,mo)
	icon.target = plmo
end

local function pawaa_appu(plr, arg)
	if not plr.mo
		print("You must be in a level to do this.")
		return
	end
	if not arg
		CONS_Printf(plr, "List of extra shields and powerups:")
		CONS_Printf(plr, "\132gr\135av\128: Receive a Gravity Shield.")
		CONS_Printf(plr, "\137star\128: Receive a Star Shield.")
		CONS_Printf(plr, "\143clock\128: Receive a Clock Shield.")
		CONS_Printf(plr, "\142gum\128: Receive a Bubblegum Shield.")
		CONS_Printf(plr, "\136combi\128: Receive a Combine Ring.")
		CONS_Printf(plr, "\130gold\128: Receive 20 seconds of Gold Rush.")
		CONS_Printf(plr, "\141socks\128: Receive 20 seconds of Spring Socks.")
		return
	end
	if arg == "grav"
		CONS_Printf(plr, "\132Go go Gadget \135Gravity Shield!")
		go_time(plr.mo,MT_GRAVITORB_ICON)
	elseif arg == "star"
		CONS_Printf(plr, "\137Go go Gadget Star Shield!")
		go_time(plr.mo,MT_STAR_ICON)
	elseif arg == "clock"
		CONS_Printf(plr, "\143Go go Gadget Clock Shield!")
		go_time(plr.mo,MT_CLOCK_ICON)
	elseif arg == "gum"
		CONS_Printf(plr, "\142Go go Gadget Bubblegum Shield!")
		go_time(plr.mo,MT_GUM_ICON)
	elseif arg == "combi"
		CONS_Printf(plr, "\136Go go Gadget Combine Ring!")
		go_time(plr.mo,MT_COMBINE_ICON)
	elseif arg == "gold"
		CONS_Printf(plr, "\130Go go Gadget Gold Rush!")
		go_time(plr.mo,MT_GRUSH_ICON)
	elseif arg == "socks"
		CONS_Printf(plr, "\141Go go Gadget Spring Socks!")
		go_time(plr.mo,MT_SOCKS_ICON)
	else
		pawaa_appu(plr, nil)
	end
end

local function pawaa_appu_tsu(plr, arg)
	if not plr.mo
		print("You must be in a level to do this.")
		return
	end
	if not arg
		CONS_Printf(plr, "List of vanilla shields and powerups:")
		CONS_Printf(plr, "\139pity\128: Receive a Pity Shield.")
		CONS_Printf(plr, "\130attr\128: Receive an Attraction Shield.")
		CONS_Printf(plr, "\137force\128: Receive a Force Shield.")
		CONS_Printf(plr, "\133nuke\128: Receive an Armageddon Shield.")
		CONS_Printf(plr, "\134wind\128: Receive a Whirlwind Shield.")
		CONS_Printf(plr, "\132el\135em\128: Receive an Elemental Shield.")
		CONS_Printf(plr, "\141aura\128: Receive a Flame Shield.")
		CONS_Printf(plr, "\138wrap\128: Receive a Bubble Shield.")
		CONS_Printf(plr, "\134coin\128: Receive a Lightning Shield.")
		CONS_Printf(plr, "\133speed\128: Receive 20 seconds of Speed Shoes.")
		CONS_Printf(plr, "\136invi\128: Receive 20 seconds of Invincibility.")
		CONS_Printf(plr, "\132boot\128: Receive 20 seconds of Gravity Boots.")
		return
	end
	if arg == "pity"
		CONS_Printf(plr, "\139Go go Gadget Pity Shield!")
		go_time(plr.mo,MT_PITY_ICON)
	elseif arg == "attr"
		CONS_Printf(plr, "\130Go go Gadget Attraction Shield!")
		go_time(plr.mo,MT_ATTRACT_ICON)
	elseif arg == "force"
		CONS_Printf(plr, "\137Go go Gadget Force Shield!")
		go_time(plr.mo,MT_FORCE_ICON)
	elseif arg == "nuke"
		CONS_Printf(plr, "\133Go go Gadget Armageddon Shield!")
		go_time(plr.mo,MT_ARMAGEDDON_ICON)
	elseif arg == "wind"
		CONS_Printf(plr, "\134Go go Gadget Whirlwind Shield!")
		go_time(plr.mo,MT_WHIRLWIND_ICON)
	elseif arg == "elem"
		CONS_Printf(plr, "\132Go go Gadget \135Elemental Shield!")
		go_time(plr.mo,MT_ELEMENTAL_ICON)
	elseif arg == "aura"
		CONS_Printf(plr, "\141Go go Gadget Flame Shield!")
		go_time(plr.mo,MT_FLAMEAURA_ICON)
	elseif arg == "wrap"
		CONS_Printf(plr, "\138Go go Gadget Bubble Shield!")
		go_time(plr.mo,MT_BUBBLEWRAP_ICON)
	elseif arg == "coin"
		CONS_Printf(plr, "\134Go go Gadget Lightning Shield!")
		go_time(plr.mo,MT_THUNDERCOIN_ICON)
	elseif arg == "speed"
		CONS_Printf(plr, "\133Go go Gadget Speed Shoes!")
		go_time(plr.mo,MT_SNEAKERS_ICON)
	elseif arg == "invi"
		CONS_Printf(plr, "\136Go go Gadget Invincibility!")
		go_time(plr.mo,MT_INVULN_ICON)
	elseif arg == "boot"
		CONS_Printf(plr, "\132Go go Gadget Gravity Boots!")
		go_time(plr.mo,MT_GRAVITY_ICON)
	else
		pawaa_appu(plr, nil)
	end
end

COM_AddCommand("esp", pawaa_appu)
COM_AddCommand("vsp", pawaa_appu_tsu)