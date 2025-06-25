-- PhysEmotes, based on Continue State Switcher by MSF and Emotes by Krabs.

freeslot("S_PLAYSIT", "S_PLAYEEPY", "S_PLAYSHET", "S_PLAYSHIT", "S_PLAYOOF_",
		 "SPR2_SIT_", "SPR2_EEPY", "SPR2_SHET", "SPR2_SHIT", "SPR2_OOF_")

states[S_PLAYSIT] = {SPR_PLAY,SPR2_SIT_|A,8,nil,0,0,S_PLAYSIT}
states[S_PLAYEEPY] = {SPR_PLAY,SPR2_EEPY|A,8,nil,0,0,S_PLAYEEPY}
states[S_PLAYSHET] = {SPR_PLAY,SPR2_SHET|A,8,nil,0,0,S_PLAYSHET}
states[S_PLAYSHIT] = {SPR_PLAY,SPR2_SHIT|A,8,nil,0,0,S_PLAYSHIT}
states[S_PLAYOOF_] = {SPR_PLAY,SPR2_OOF_|A,8,nil,0,0,S_PLAYOOF_}