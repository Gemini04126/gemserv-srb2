//this is really basic, but I hope it's nice for people that like this kinda thing
//well now it's less basic and actually works with lua scripts that tamper with the flag because it'll force you to become colored so that's epic
//created by Sylve
local function colorizeToggle(p) //yeah no more being stuck in a command, but basically sets the extra var that isn't affected by normal gameplay
	if (p.fcolorize == false) then
		p.fcolorize = true
	else 
		p.fcolorize = false
	end
end

local function petColorizeToggle(p) //yeah no more being stuck in a command, but basically sets the extra var that isn't affected by normal gameplay
	if (p.pet)
		if (p.pet.fcolorize == false) then
			p.pet.fcolorize = true
		else 
			p.pet.fcolorize = false
		end
	end
end

COM_AddCommand("colorize", function(p)
	colorizeToggle(p)
	if p.fcolorize == true //this is a little messy but I wasn't sure how else to stick this in here so my apologies :pensive: (same applies to chat print)
		CONS_Printf(p, "You are now colorized!")
	else
		CONS_Printf(p, "You are no longer colorized.")
	end
end)

COM_AddCommand("petcolorize", function(p)
	if (p.pet) then
		if not (p.mo.pet.color == SKINCOLOR_NONE) then
			petColorizeToggle(p)
			if p.pet.fcolorize == true then
				CONS_Printf(p, "Your pet is now colorized!")
			else
				CONS_Printf(p, "Your pet is no longer colorized.")
			end
		else
			CONS_Printf(p, "Your pet cannot be colorized.") //yeah it only works on pets with colors sorry :(
		end
	else
		CONS_Printf(p, "Please add Pets to use this command.")
	end
end)


addHook("PlayerThink", function(p) //init and forcing of flag
	if not p.fcolorize then
		p.fcolorize = false
	end
	if p.fcolorize == true then
		p.mo.colorized = true
	else
		p.mo.colorized = false		
	end
	if (p.pet) then //pets don't exist sometimes
		if not p.pet.fcolorize then
			p.pet.fcolorize = false
		end
		if p.pet.fcolorize == true then
			p.mo.pet.colorized = true
		else
			p.mo.pet.colorized = false
		end
	end
end, MT_PLAYER)

addHook("PlayerMsg", function(p, _, _, msg) //that's right baby chat support (only for players since pets don't have chat support in general)
	if msg == ".colorize"
		colorizeToggle(p)
		if p.fcolorize == true
			chatprintf(p, "\x86You are now colorized!")
		else
			chatprintf(p, "\x86You are no longer colorized.")
		end
		return true
	end
end)