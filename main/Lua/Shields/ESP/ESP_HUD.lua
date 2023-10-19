local function hud_extraicon(v,player)
	if not player.mo return end
	if not (CV_FindVar("powerupdisplay").value == 2 or (CV_FindVar("powerupdisplay").value == 1 and R_PointToDist(player.mo.x, player.mo.y) < FRACUNIT))
		return
	end

	local x = hudinfo[HUD_POWERUPS].x*FRACUNIT
	local y = hudinfo[HUD_POWERUPS].y*FRACUNIT
	local f = V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_PERPLAYER
	local sep = 20*FRACUNIT

	if player.pflags & PF_FINISHED and CV_FindVar("exitmove").value and multiplayer
		x = $ - sep
	end

	if player.powers[pw_shield] & SH_NOSTACK
		if player.powers[pw_shield] == SH_GRAVITY
			v.drawScaled(x,y,FRACUNIT/2,v.cachePatch("VMGBICON"),f)
		elseif player.powers[pw_shield] == SH_STAR
			v.drawScaled(x,y,FRACUNIT/2,v.cachePatch("VMSBICON"),f)
		elseif player.powers[pw_shield] == SH_CLOCK
			v.drawScaled(x,y,FRACUNIT/2,v.cachePatch("VMCBICON"),f)
		elseif player.powers[pw_shield] == SH_GUM
			v.drawScaled(x,y,FRACUNIT/2,v.cachePatch("VMBBICON"),f)
		end
		x = $ - sep
	end

	if player.gotflag
		x = $ - sep
	end
	if player.powers[pw_invulnerability] or player.powers[pw_flashing]
		x = $ - sep
	end
	if player.powers[pw_sneakers]
		x = $ - sep
	end
	if player.powers[pw_gravityboots]
		x = $ - sep
	end

	if player.mo.pw_combine
		v.drawScaled(x,y,FRACUNIT/2,v.cachePatch("VMCMICON"),f)
		x = $ - sep
	end
	if player.mo.pw_goldrush
		if player.mo.pw_goldrush > 3*TICRATE or (player.mo.pw_goldrush and leveltime % 2)
			v.drawScaled(x,y,FRACUNIT/2,v.cachePatch("VMRHICON"),f)
			v.drawString(x+16*FRACUNIT,y+8*FRACUNIT,tostring(player.mo.pw_goldrush/TICRATE),f,"thin-fixed-right")
		end
		x = $ - sep
	end
	if player.mo.pw_springsocks
		if player.mo.pw_springsocks > 3*TICRATE or (player.mo.pw_springsocks and leveltime % 2)
			v.drawScaled(x,y,FRACUNIT/2,v.cachePatch("VMSCICON"),f)
			v.drawString(x+16*FRACUNIT,y+8*FRACUNIT,tostring(player.mo.pw_springsocks/TICRATE),f,"thin-fixed-right")
		end
		x = $ - sep
	end
end

hud.add(hud_extraicon)