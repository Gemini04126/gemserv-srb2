print()
print("JoinSFX has been added! There will now be a sound effect played when a player joins your server.")
print()
print("The sound can be chosen from a list of varying sounds, and is quite simple to use.")
print()
print("To get started, type 'joinsfx list', 'joinsfx help', or just 'joinsfx' in the console!")
print()
print("It is also worth knowing that ONLY THE SERVER HOST may use this command.")
print("If any other player tries to use it, they'll be informed of the host requirement.")
print()
print("NOTE: As of the current version of this script, rejointimeout is NOT supported.")
print("Nothing will break, but a sound won't play if someone rejoins.")
print()

freeslot(
"sfx_sotnlv",
"sfx_kcoin",
"sfx_badt",
"sfx_galaga",
"sfx_dhunt",
"sfx_kong",
"sfx_flash",
"sfx_uthero"
)

sfxinfo[sfx_sotnlv] = {
	singular = false,
	caption = "Castlevania?"
}

sfxinfo[sfx_badt] = {
	singular = false,
	caption = "*Bad Time*"
}

sfxinfo[sfx_kcoin] = {
	singular = false,
	caption = "Kremcoin"
}

sfxinfo[sfx_galaga] = {
	singular = false,
	caption = "Galaga Level Start"
}

sfxinfo[sfx_dhunt] = {
	singular = false,
	caption = "Duck Caught"
}

sfxinfo[sfx_kong] = {
	singular = false,
	caption = "Free 100 Points"
}

sfxinfo[sfx_flash] = {
	singular = false,
	caption = "Flash"
}

sfxinfo[sfx_uthero] = {
	singular = false,
	caption = "Legendary Hero"
}

local jsfx = 0

COM_AddCommand("joinsfx", function(player, sfx)
if ((player ~= server) and (IsPlayerAdmin(player) ~= true))
	CONS_Printf(player,"You must be the server host or a remote admin to use this.")
else
for player in players.iterate
	if sfx == none or string.lower(sfx) == "help"
		CONS_Printf(player,"Use 'joinsfx list' to get a list of supported sounds to put after the base command!")

elseif string.lower(sfx) == "list" then
		CONS_Printf(player,"")
		CONS_Printf(player,">none")	
		CONS_Printf(player,"Disables the join SFX entirely.")
		CONS_Printf(player,">jump")	
		CONS_Printf(player,"The general jump SFX.")
		CONS_Printf(player,">spin")
		CONS_Printf(player,"The general rolling SFX.")
		CONS_Printf(player,">spndsh")
		CONS_Printf(player,"The general Spindash charging SFX.")
		CONS_Printf(player,">thok")
		CONS_Printf(player,"The thok SFX.")
		CONS_Printf(player,">zoom")
		CONS_Printf(player,"The general 'Zoom' SFX.")
		CONS_Printf(player,">skid")
		CONS_Printf(player,"The general skidding SFX")
		CONS_Printf(player,">alarm")
		CONS_Printf(player,"An alarm SFX.")
		CONS_Printf(player,">splash")
		CONS_Printf(player,"*water noises*")
		CONS_Printf(player,">splish")
		CONS_Printf(player,"*water noises intensify")
		CONS_Printf(player,">bkpoof")
		CONS_Printf(player,"Armageddon blast SFX.")
		CONS_Printf(player,">cgot")
		CONS_Printf(player,"SFX for collecting a Chaos Emerald.")
		CONS_Printf(player,">gravch")
		CONS_Printf(player,"SFX of a Recycle monitor.")
		CONS_Printf(player,">itemup")
		CONS_Printf(player,"Ring.")
		CONS_Printf(player,">lose")
		CONS_Printf(player,"No way! No way? No way!")
		CONS_Printf(player,">ding")
		CONS_Printf(player,"A soft ding SFX.")
		CONS_Printf(player,">monton")
		CONS_Printf(player,"SFX used when a Golden Monitor is powering on.")
		CONS_Printf(player,">pop")
		CONS_Printf(player,"SFX used when destroying a badnik or monitor.")
		CONS_Printf(player,">strpst")
		CONS_Printf(player,"SFX used when hitting a checkpoint.")
		CONS_Printf(player,">token")
		CONS_Printf(player,"SFX used when picking up an Emerald Token.")
		CONS_Printf(player,">pscree")
		CONS_Printf(player,"The SFX heard when a Pterabtye swoops at a player.")
		CONS_Printf(player,">emfind")
		CONS_Printf(player,"Emblem Radar SFX.")
		CONS_Printf(player,">s3k68")
		CONS_Printf(player,"A 'Discovery' SFX.")
		CONS_Printf(player,">3db06")
		CONS_Printf(player,"Sound of a Flicky being collected. Not like they're collectible in this game, though.")
		CONS_Printf(player,">kc42")
		CONS_Printf(player,"A confirmation SFX.")
		CONS_Printf(player,">kc48")
		CONS_Printf(player,"A selection SFX.")
		CONS_Printf(player,">hoop1")
		CONS_Printf(player,"First sound for a Nights Hoop.")
		CONS_Printf(player,">sotnlv")
		CONS_Printf(player,"The level up SFX from Castlevania: Symphony of the Night.")
		CONS_Printf(player,">kcoin")
		CONS_Printf(player,"Sound of a Kremcoin being collected from Donkey Kong Country 2.")
		CONS_Printf(player,">badt")
		CONS_Printf(player,"*You feel your sins crawling on your back.")
		CONS_Printf(player,">galaga")
		CONS_Printf(player,"Get your quarters ready.")
		CONS_Printf(player,">dhunt")
		CONS_Printf(player,"*Laughs in dog*")
		CONS_Printf(player,">kong")
		CONS_Printf(player,"Jumping over barrels never sounded so good.")
		CONS_Printf(player,">flash")
		CONS_Printf(player,"A sound of a flash from another game.")
		CONS_Printf(player,">uthero")
		CONS_Printf(player,"A sound of... eating a sandwich, also from another game.")
		CONS_Printf(player,"")
		CONS_Printf(player,"Use the Page Up and Page Down keys to scroll through the above list!")

elseif string.lower(sfx) == "none" then
		jsfx = 0
		CONS_Printf(player,"Join SFX disabled.")

elseif string.lower(sfx) == "jump" then
		jsfx = sfx_jump
		CONS_Printf(player,"Join SFX set to [Jump]")

elseif string.lower(sfx) == "spin" then
		jsfx = sfx_spin
		CONS_Printf(player,"Join SFX set to [Spin]")

elseif string.lower(sfx) == "spndsh" then
		jsfx = sfx_spndsh
		CONS_Printf(player,"Join SFX set to [Spindash Charge]")

elseif string.lower(sfx) == "thok" then
		jsfx = sfx_thok
		CONS_Printf(player,"Join SFX set to [Thok]")

elseif string.lower(sfx) == "zoom" then
		jsfx = sfx_zoom
		CONS_Printf(player,"Join SFX set to [Zoom]")

elseif string.lower(sfx) == "skid" then
		jsfx = sfx_skid
		CONS_Printf(player,"Join SFX set to [Skid]")

elseif string.lower(sfx) == "alarm" then
		jsfx = sfx_alarm
		CONS_Printf(player,"Join SFX set to [Alarm]")

elseif string.lower(sfx) == "splash" then
		jsfx = sfx_splash
		CONS_Printf(player,"Join SFX set to [Splash]")

elseif string.lower(sfx) == "splish" then
		jsfx = sfx_splish
		CONS_Printf(player,"Join SFX set to [Splish]")

elseif string.lower(sfx) == "bkpoof" then
		jsfx = sfx_bkpoof
		CONS_Printf(player,"Join SFX set to [Armageddon pow]")

elseif string.lower(sfx) == "cgot" then
		jsfx = sfx_cgot
		CONS_Printf(player,"Join SFX set to [Got Chaos Emerald]")

elseif string.lower(sfx) == "gravch" then
		jsfx = sfx_gravch
		CONS_Printf(player,"Join SFX set to [Recycler]")

elseif string.lower(sfx) == "itemup" then
		jsfx = sfx_itemup
		CONS_Printf(player,"Join SFX set to [Ring]")

elseif string.lower(sfx) == "lose" then
		jsfx = sfx_lose
		CONS_Printf(player,"Join SFX set to [Lose]")

elseif string.lower(sfx) == "ding" then
		jsfx = sfx_ding
		CONS_Printf(player,"Join SFX set to [Ding]")

elseif string.lower(sfx) == "monton" then
		jsfx = sfx_monton
		CONS_Printf(player,"Join SFX set to [Golden Monitor Powering On]")

elseif string.lower(sfx) == "pop" then
		jsfx = sfx_pop
		CONS_Printf(player,"Join SFX set to [Pop]")

elseif string.lower(sfx) == "strpst" then
		jsfx = sfx_strpst
		CONS_Printf(player,"Join SFX set to [Starpost]")

elseif string.lower(sfx) == "token" then
		jsfx = sfx_token
		CONS_Printf(player,"Join SFX set to [Emerald Token]")

elseif string.lower(sfx) == "pscree" then
		jsfx = sfx_pscree
		CONS_Printf(player,"Join SFX set to [SCREE!]")

elseif string.lower(sfx) == "emfind" then
		jsfx = sfx_emfind
		CONS_Printf(player,"Join SFX set to [Emblem Radar Blip]")

elseif string.lower(sfx) == "s3k68" then
		jsfx = sfx_s3k68
		CONS_Printf(player,"Join SFX set to [Discovery]")

elseif string.lower(sfx) == "3db06" then
		jsfx = sfx_3db06
		CONS_Printf(player,"Join SFX set to [Collectible]")

elseif string.lower(sfx) == "kc42" then
		jsfx = sfx_kc42
		CONS_Printf(player,"Join SFX set to [Confirm]")

elseif string.lower(sfx) == "kc48" then
		jsfx = sfx_kc48
		CONS_Printf(player,"Join SFX set to [Select]")
elseif string.lower(sfx) == "sotnlv" then
		jsfx = sfx_sotnlv
		CONS_Printf(player,"Join SFX set to [Level Up]")
elseif string.lower(sfx) == "kcoin" then
		jsfx = sfx_kcoin
		CONS_Printf(player,"Join SFX set to [Kremcoin]")
elseif string.lower(sfx) == "hoop1" then
		jsfx = sfx_hoop1
		CONS_Printf(player,"Join SFX set to [Hoop]")
elseif string.lower(sfx) == "badt" then
		jsfx = sfx_badt
		CONS_Printf(player,"Join SFX set to [*Bad Time*]")
elseif string.lower(sfx) == "galaga" then
		jsfx = sfx_galaga
		CONS_Printf(player,"Join SFX set to [Galaga]")
elseif string.lower(sfx) == "dhunt" then
		jsfx = sfx_dhunt
		CONS_Printf(player,"Join SFX set to [Duck Caught]")
elseif string.lower(sfx) == "kong" then
		jsfx = sfx_kong
		CONS_Printf(player,"Join SFX set to [Donkey Kong SFX]")
elseif string.lower(sfx) == "flash" then
		jsfx = sfx_flash
		CONS_Printf(player,"Join SFX set to [Flash]")
elseif string.lower(sfx) == "uthero" then
		jsfx = sfx_uthero
		CONS_Printf(player,"Join SFX set to [Legendary Hero]")
else
		CONS_Printf(player,"Please enter a valid SFX name.")
		
				end
			end
		end
	end)

addHook("NetVars", function(net)
	jsfx = net(jsfx)
end)

addHook("PlayerJoin", function(playernum)
S_StartSound(nil, jsfx)
end)