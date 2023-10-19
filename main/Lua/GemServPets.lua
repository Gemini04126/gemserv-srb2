//copy this lua file and customise to add your own pets!!
freeslot(
"SPR_FLKY", // Flicky (colorable, dunno if this'll work...)
"SPR_RUNK", // Unknown with rotations
"SPR_GBUZ", // recolorable buzz lmao
"SPR_DONG", // dk sprites by PetoMico (TSR)
"SPR_HEAD", // cacodemon sprites reduced to 75% size
"SPR_TDOL", // tails doll sprites from srb2 battle by cobaltbw
"SPR_PHAN", // phanto sprites by Omega (TSR)
"SPR_METT", // Mettool (MM8BDM), edited to add a propeller
"SPR_BBAT", // Bubble Bat ^
"SPR_BLAD", // Blader ^
"SPR_TELY", // Telly ^
"SPR_BUNB", // Bunby ^
"SPR_DEBU", // Debut Sonic (MCTravisYT)
"SPR_S1SO", // S1 Sonic (Going with the camera)
"SPR_S1SS", // S1 Sonic (SPEEEEEN)
"SPR_SONG",	// Song (Sheriff Domestic)
"SPR_STLO",	// Starlow (3DS Mario & Luigi games)
"SPR_BOO_",	// Boo (3DS Mario & Luigi games)
"SPR_BOOD", // Boo [old] (Bowser's Inside Story)
"SPR_REIM",	// Reimu Hakurei (S3K Style) by Hartflip0218 (TSR)
"SPR_CIR2"	// Cirno (Shin Touhou Musou)
)

local PetsToAdd = {
	UnknownRotate = {
		SpriteSet = SPR_RUNK,
		ShadowScale = FRACUNIT/2,
		Anims = {
			Idle = {A, A, 1},
		}
	},

	-- colorable-ness added by Gemini0
	Flicky = {
		SpriteSet = SPR_FLKY,
		ShadowScale = FRACUNIT/4,
		Color = "cornflower",
		Anims = {
			Idle = {A, C, 3},
		}
	},

	Buzz = {
		SpriteSet = SPR_GBUZ,
		ShadowScale = FRACUNIT,
		Color = "red",
		Anims = {
			Idle = {A, B, 2},
		}
	},
	
	JettyBomber = {
		SpriteSet = SPR_JETB,
		ShadowScale = FRACUNIT,
		Anims = {
			Idle = {A, B, 1},
		}
	},
	
	JettyGunner = {
		SpriteSet = SPR_JETG,
		ShadowScale = FRACUNIT,
		Anims = {
			Idle = {A, B, 1},
		}
	},
	
	Bumblebore = {
		SpriteSet = SPR_BUMB,
		ShadowScale = FRACUNIT/2,
		Anims = {
			Idle = {A, B, 4},
		}
	},
	
	Pointy = {
		SpriteSet = SPR_PNTY,
		ShadowScale = FRACUNIT/2,
		Anims = {
			Idle = {A, A, 1},
		}
	},
	
	CrawlaCommander = {
		SpriteSet = SPR_CCOM,
		ShadowScale = FRACUNIT,
		Anims = {
			Idle = {A, D, 1},
		}
	},
	
	DonkeyKong = {
		SpriteSet = SPR_DONG,
		ShadowScale = FRACUNIT/2,
		Anims = {
			Idle = {A, D, 2},
		}
	},
	
	Cacodemon = {
		SpriteSet = SPR_HEAD,
		ShadowScale = FRACUNIT,
		Anims = {
			Idle = {A, A, 1},
		}
	},
	
	TailsDoll = {
		SpriteSet = SPR_TDOL,
		ShadowScale = FRACUNIT,
		Color = "orange",
		Anims = {
			Idle = {A, A, 1},
		}
	},
	
	Phanto = {
		SpriteSet = SPR_PHAN,
		ShadowScale = FRACUNIT/2,
		Color = "red",
		Anims = {
			Idle = {A, A, 1},
		}
	},
	
	Mettool = {
		SpriteSet = SPR_METT,
		ShadowScale = FRACUNIT/2,
		Anims = {
			Idle = {A, B, 3},
		}
	},
	
	BubbleBat = {
		SpriteSet = SPR_BBAT,
		ShadowScale = FRACUNIT/2,
		Anims = {
			Idle = {A, C, 5},
		}
	},
	
	Blader = {
		SpriteSet = SPR_BLAD,
		ShadowScale = FRACUNIT/2,
		Anims = {
			Idle = {A, B, 3},
		}
	},
	
	
	Telly = {
		SpriteSet = SPR_TELY,
		ShadowScale = FRACUNIT/2,
		Anims = {
			Idle = {A, F, 7},
		}
	},
	
	
	Bunby = {
		SpriteSet = SPR_BUNB,
		ShadowScale = FRACUNIT/2,
		Anims = {
			Idle = {A, B, 3},
		}
	},
	
	S1SonicFloat = {
		SpriteSet = SPR_S1SO,
		ShadowScale = FRACUNIT/2,
		Color = "azure",
		Anims = {
			Idle = {A, A, 1},
		}
	},
// Officially got me fucked up
	DebutSonic = {
		SpriteSet = SPR_DEBU,
		ShadowScale = FRACUNIT/2,
		Color = "cornflower",
		Anims = {
			Idle = {A, H, 5},
		}
	},
	
	S1SonicSpin = {
		SpriteSet = SPR_S1SS,
		ShadowScale = FRACUNIT/2,
		Color = "azure",
		Anims = {
			Idle = {A, J, 4},
		}
	},
	
	S1SonicSpeeen = {
		SpriteSet = SPR_S1SS,
		ShadowScale = FRACUNIT/2,
		Color = "azure",
		Anims = {
			Idle = {A, J, 1},
		}
	},
	
	BooDS = {
		SpriteSet = SPR_BOOD,
		ShadowScale = FRACUNIT,
		Color = "silver", // changed from white because silver starts the same and ends really dark so it works out just fine
		Anims = {
			Idle = {A, D, 4},
		}
	},
	
	Song = {
		SpriteSet = SPR_SONG,
		ShadowScale = FRACUNIT/2,
		Color = "sky",
		Anims = {
			Idle = {A, B, 2},
			Dead = {C, D, 2}
		}
	},
	
	Starlow = {
		SpriteSet = SPR_STLO,
		ShadowScale = FRACUNIT/2,
		Color = "yellow",
		Anims = {
			Idle = {A, F, 2}
		}
	},
	
	Boo = {
		SpriteSet = SPR_BOO_,
		ShadowScale = FRACUNIT,
		Color = "silver", // changed from white because silver starts the same and ends really dark so it works out just fine
		Anims = {
			Idle = {A, J, 2},
		}
	},
	
	Reimu = {
		SpriteSet = SPR_REIM,
		ShadowScale = FRACUNIT/2,
		Color = "red",
		Anims = {
			Idle = {A, A, 1},
		}
	},
	
	ReimuFloat = {
		SpriteSet = SPR_REIM,
		ShadowScale = FRACUNIT/2,
		Color = "red",
		Anims = {
			Idle = {B, B, 1},
		}
	},
	
	ReimuSpin = {
		SpriteSet = SPR_REIM,
		ShadowScale = FRACUNIT/2,
		Color = "red",
		Anims = {
			Idle = {C, J, 4},
		}
	},
	
	ReimuSpeeen = {
		SpriteSet = SPR_REIM,
		ShadowScale = FRACUNIT/2,
		Color = "red",
		Anims = {
			Idle = {C, J, 1},
		}
	},
	
	Cirno2 = {
		SpriteSet = SPR_CIR2,
		ShadowScale = FRACUNIT/2,
		Color = "sky",
		Anims = {
			Idle = {A, B, 4},
			Jump = {C, F, 2},
			Dead = {G, G, 1},
			Move = {A, B, 1}
		}
	},
}
if (Pet_AddPet) then
	for petname,petinfo in pairs(PetsToAdd)
		Pet_AddPet(petinfo, petname)
	end
end