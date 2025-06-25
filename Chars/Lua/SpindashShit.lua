freeslot(
"sfx_shisd0",
"sfx_shisd1",
"sfx_shisd2",
"sfx_shisd3",
"sfx_shisd4",
"sfx_shisd5",
"sfx_shisd6",
"sfx_shisd7",
"sfx_shisd8",
"sfx_shisd9",
"sfx_shisda",
"sfx_shisdb",
"sfx_shisdc",
"sfx_shisdd",
"sfx_shisde",
"sfx_shisdf"
)

sfxinfo[sfx_shisd0] = {
	singular = false,
	caption = "Spindash"
}
sfxinfo[sfx_shisd1] = {
	singular = false,
	caption = "Spindash"
}
sfxinfo[sfx_shisd2] = {
	singular = false,
	caption = "Spindash"
}
sfxinfo[sfx_shisd3] = {
	singular = false,
	caption = "Spindash"
}
sfxinfo[sfx_shisd4] = {
	singular = false,
	caption = "Spindash"
}
sfxinfo[sfx_shisd5] = {
	singular = false,
	caption = "Spindash"
}
sfxinfo[sfx_shisd6] = {
	singular = false,
	caption = "Spindash"
}
sfxinfo[sfx_shisd7] = {
	singular = false,
	caption = "Spindash"
}
sfxinfo[sfx_shisd8] = {
	singular = false,
	caption = "Spindash"
}
sfxinfo[sfx_shisd9] = {
	singular = false,
	caption = "Spindash"
}
sfxinfo[sfx_shisda] = {
	singular = false,
	caption = "Spindash"
}
sfxinfo[sfx_shisdb] = {
	singular = false,
	caption = "Spindash"
}
sfxinfo[sfx_shisdc] = {
	singular = false,
	caption = "Spindash"
}
sfxinfo[sfx_shisdd] = {
	singular = false,
	caption = "Spindash"
}
sfxinfo[sfx_shisde] = {
	singular = false,
	caption = "Spindash"
}
sfxinfo[sfx_shisdf] = {
	singular = false,
	caption = "Spindash"
}

//HELL YEAH
//Classic spindash behavior by rumia1!
// taken from NordChars with permission from Fen
addHook("ThinkFrame", do
	for player in players.iterate
		if player.mo and player.mo.valid
		and not (player.mo.state == S_PLAY_DEAD)
			if (player.mo.skin == "sonic" or player.mo.skin == "tails" or player.mo.skin == "knuckles" or player.mo.skin == "metalsonic" or player.mo.skin == "mighty")
			//setting up the variable to check for how many charges the current spindash has
				if player.spincharges == nil
					player.spincharges = 0
				end
			//this one checks how long the spindash has been held for
				if player.dashtime == nil
				or not (player.pflags & PF_STARTDASH)
					player.dashtime = 15
				end
			//and this one checks how many automatic charges we've added, as we can only have 4
				if player.dashcounter == nil
				or not (player.pflags & PF_STARTDASH)
					player.dashcounter = 0
				end
			//checks if player was holding jump last frame
				if player.jumpwasdown == nil
					player.jumpwasdown = 0
				end
				
				if player.forwardwasdown == nil
					player.forwardwasdown = 0
				end
				if player.backwasdown == nil
					player.backwasdown = 0
				end
				if player.leftwasdown == nil
					player.leftwasdown = 0
				end
				if player.rightwasdown == nil
					player.rightwasdown = 0
				end
				
			//makes our life easier
 				if player.pflags & PF_STARTDASH
 					player.dashspeed = player.maxdash
 					player.mindash = player.maxdash - (21*player.dashspeed)
 				end
		
				if player.dashcounter >= 3
					player.dashcounter = 3
				end
				if player.dashtime <= 0
					player.dashtime = 15
				end
				if testing == true then print(player.dashcounter, player.dashtime, player.dashspeed/FRACUNIT, player.spincharges) end
				if (player.pflags & PF_STARTDASH)
					player.jumpfactor = 0
					player.dashtime = $ - 1
					if player.spincharges == 0
						player.mindash = 23*FRACUNIT
						player.maxdash = 25*FRACUNIT
						player.mindash = player.maxdash - (21*player.dashspeed)
					else
						player.maxdash = (25*FRACUNIT) + (player.spincharges*(5*FRACUNIT))
					end
					if (player.cmd.forwardmove >= 25)
					and not (player.forwardwasdown)
					or (player.cmd.forwardmove <= -25)
					and not (player.backwasdown)
					or (player.cmd.sidemove >= 25)
					and not (player.rightwasdown)
					or (player.cmd.sidemove <= -25)
					and not (player.leftwasdown)
					or (player.cmd.buttons & BT_JUMP)
					and not (player.jumpwasdown)
						if player.spincharges < 15
							player.spincharges = $ + 1
						else
							player.spincharges = 15
						end
						S_StopSound(player.mo)
					-- add a check for whether they're using shisd0 or the default. or s3kab
						S_StartSound(player.mo, sfx_shisd0 + player.spincharges)
					end

				else
					player.jumpfactor = skins[player.mo.skin].jumpfactor
					player.spincharges = 0
				end
			//Our "was jump pressed last frame?" check ends here
				player.jumpwasdown = (player.cmd.buttons & BT_JUMP)
				if (player.cmd.forwardmove >= 25)
					player.forwardwasdown = 1
				else
					player.forwardwasdown = 0
				end
				if (player.cmd.forwardmove <= -25)
					player.backwasdown = 1
				else
					player.backwasdown = 0
				end
				if (player.cmd.sidemove >= 25)
					player.rightwasdown = 1
				else
					player.rightwasdown = 0
				end
				if (player.cmd.sidemove <= -25)
					player.leftwasdown = 1
				else
					player.leftwasdown = 0
				end
			end
		end
	end
end)