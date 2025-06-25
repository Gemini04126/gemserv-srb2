freeslot(
	"S_MKMA","SPR_MKMA",
	"S_STEJ","SPR_STEJ",
	"S_FTEJ","SPR_FTEJ",
	"S_EJ__","SPR_EJ__",
	"S_MARH","SPR_MARH",
	"S_LUIH","SPR_LUIH",
	"S_CLAN","SPR_CLAN",
	"sfx_txtpap", "sfx_hitut", "sfx_glassb", "sfx_soulbk", "sfx_pombrk", "sfx_ahaha"
)
states[S_MKMA].sprite = SPR_MKMA
states[S_STEJ].sprite = SPR_STEJ
states[S_FTEJ].sprite = SPR_FTEJ
states[S_EJ__].sprite = SPR_EJ__
states[S_MARH].sprite = SPR_MARH
states[S_LUIH].sprite = SPR_LUIH
states[S_CLAN].sprite = SPR_CLAN
for i = S_MKMA, S_CLAN
	states[i].tics = -1 --Prevents the hat from disappearing instantly
end

local sparkZap = function(mo)
	if leveltime % 20 == 0
		local fl = P_MobjFlip(mo.target)
		local spark = P_SpawnMobj(mo.x,mo.y,mo.z + (FRACUNIT * fl),MT_SPINDUST)
		spark.momx = (2 * FRACUNIT) * P_RandomRange(-3, 3)
		spark.momy = (2 * FRACUNIT) * P_RandomRange(-3, 3)
		spark.momz = (P_RandomRange(0, 1) * FRACUNIT) * fl
		spark.fuse = 9
		spark.state = S_COINSPARKLE1
		spark.color = SKINCOLOR_GOLDENROD
		spark.colorized = true
	end
end

if Cosmetics
	Cosmetics.SkinOffsets["mctails"] = -4
	Cosmetics.SkinOffsets["mcamy"] = -4
	Cosmetics.AddHat("Meta Knight's Mask",		"comfycookie",		"MKMAA2A8",	S_MKMA, false,	nil)
	Cosmetics.AddHat("Electric Jester",			"HattyBoyo, edited by Gemini0",	"STEJA2",	S_STEJ, false,	sparkZap)
	Cosmetics.AddHat("Fake Jester",				"HattyBoyo, edited by Gemini0",	"FTEJA2",	S_FTEJ, false,	sparkZap)
	Cosmetics.AddHat("Copy Jester",				"HattyBoyo, edited by Gemini0",	"EJ__A2",	S_EJ__, false,	sparkZap)
	Cosmetics.AddHat("Red Plumber",				"AlphaDream",		"MARHA2A8", S_MARH,	false,	nil)
	Cosmetics.AddHat("Green Plumber",			"AlphaDream",		"LUIHA2A8", S_LUIH,	false,	nil)
	Cosmetics.AddHat("Cacolantern",				"Sonic Team Jr.",	"CLANA2A8",	S_CLAN,	false,	nil)
	Cosmetics.AddDeathsound("Glass Break",sfx_glassb)
	Cosmetics.AddDeathsound("SOUL Break",sfx_soulbk)
	Cosmetics.AddHitsound("Undertale",sfx_hitut)
	Cosmetics.AddChatsound("THE GREAT PAPYRUS!",sfx_txtpap)
	Cosmetics.AddChatsound("Pomeranian Bark",sfx_pombrk)
	Cosmetics.AddChatsound("Golden Witch's Cackle",sfx_ahaha)
end