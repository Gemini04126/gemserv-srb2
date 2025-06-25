--[[ Cancel Super Form rewrite
Made this just for in case someone doesn't like MMT for some reason, but wants this. It's just code taken from MMT.
]]

COM_AddCommand("disablerevertbutton", function(player)
  -- For people who want to use all the features of a character, without getting kicked out of their Super form.
  if player.disablerevertbutton then
    player.disablerevertbutton = false
    CONS_Printf(player, "Super revert button (tossflag) has been enabled.")
  else
    player.disablerevertbutton = true
    CONS_Printf(player, "Super revert button (tossflag) has been disabled.")
  end
end)

addHook("MobjThinker", function(mobj) local player = mobj.player

local function SoupTime()
	if (player.powers[pw_flashing] < TICRATE)
	and not player.waittogetdown
	and (not (player.pflags & PF_THOKKED) or player.PreviousFrameThok)
	and not (player.pflags & PF_SHIELDABILITY)
	and not (player.pflags & PF_FINISHED)
	and not (player.pflags & PF_SPINNING)
	and (everysuper != "disable")
	and not ((player.mo.state == S_PLAY_SUPER_TRANS1) or (player.mo.state == S_PLAY_SUPER_TRANS2) or (player.mo.state == S_PLAY_SUPER_TRANS3) or (player.mo.state == S_PLAY_SUPER_TRANS4) or (player.mo.state == S_PLAY_SUPER_TRANS5) or (player.mo.state == S_PLAY_SUPER_TRANS6))
	and not player.HasGlided
	and (player.playerstate == PST_LIVE)
	and P_IsObjectOnGround(player.mo)
	and (player.disablerevertbutton == false)
	and not mmtVersion
		return true
	else
		return false
	end
end

	if SoupTime() and player.powers[pw_super] and player.cmd.buttons & BT_TOSSFLAG
		player.pflags = $1 | PF_THOKKED
		P_SpawnShieldOrb(player)
		player.powers[pw_flashing] = TICRATE
		player.powers[pw_super] = 0
		player.mo.color = player.skincolor
		P_RestoreMusic(player)
	end
end, MT_PLAYER)